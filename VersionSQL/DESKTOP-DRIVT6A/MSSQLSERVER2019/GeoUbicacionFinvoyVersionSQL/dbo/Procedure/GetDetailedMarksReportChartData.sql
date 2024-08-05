/****** Object:  Procedure [dbo].[GetDetailedMarksReportChartData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 26/11/2015
-- Description:	SP para obtener un reporte de marcas realizadas agrupado por persona
-- =============================================
CREATE PROCEDURE [dbo].[GetDetailedMarksReportChartData]
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](1000) = NULL
	,@Types [sys].[varchar](1000) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
	,@MaxPersonsCount [sys].[int]
	,@ResultCode [sys].[int] OUT
AS
BEGIN
	DECLARE @PersonsCount [sys].[int] = 0

	SELECT @PersonsCount = COUNT( DISTINCT IdPersonOfInterest) 
	FROM	[dbo].[Mark] M WITH(NOLOCK)
	WHERE	[type] ='E' AND Tzdb.IsGreaterOrSameSystemDate([Date], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate([Date], @DateTo) = 1

	IF @MaxPersonsCount < @PersonsCount
	BEGIN
		SET @ResultCode = 1
	END
	ELSE
	BEGIN
		SET @ResultCode = 0
		;WITH ViewDetailedMarksReport([Id], [IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude]) AS
		(
			SELECT	[Id], [IdPersonOfInterest], [Type], [Date], [Latitude], [Longitude]
			FROM	[dbo].[Mark] M WITH(NOLOCK)
			WHERE	[type] ='E'
					AND Tzdb.IsGreaterOrSameSystemDate([Date], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate([Date], @DateTo) = 1
		)

		SELECT		VDMR.[IdPersonOfInterest], S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier,
					SUM(CONVERT([sys].[bigint], CASE
						WHEN SMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN DATEDIFF(ms, VDMR.[Date], SMark.[Date])
						WHEN SMark.[Date] IS NULL AND SDMark.[Date] IS NOT NULL AND VDMR.[Date]IS NOT NULL THEN DATEDIFF(ms, VDMR.[Date], SDMark.[Date])
						WHEN SMark.[Date] IS NULL AND EDMark.[Date] IS NOT NULL AND VDMR.[Date] IS NOT NULL THEN DATEDIFF(ms, VDMR.[Date], EDMark.[Date])
						ELSE 0
						END)) AS WorkedHours,
					SUM(CONVERT([sys].[bigint], CASE
						WHEN SDMark.[Date] IS NOT NULL AND EDMark.[Date] IS NOT NULL THEN DATEDIFF(ms, EDMark.[Date], SDMark.[Date])
						ELSE 0
						END)) AS RestedHours
		FROM		ViewDetailedMarksReport VDMR
					--INNER JOIN [dbo].[AvailablePersonOfInterest] S WITH(NOLOCK) ON S.[Id] = VDMR.[IdPersonOfInterest] SE CAMBIA PARA QUE APAREZCAN LOS ELIMINADOS
					INNER JOIN [dbo].[PersonOfInterest] S WITH(NOLOCK) ON S.[Id] = VDMR.[IdPersonOfInterest]
					LEFT OUTER JOIN [dbo].[PersonOfInterestSchedule] SS WITH(NOLOCK) ON SS.[IdPersonOfInterest] = S.[Id] AND SS.[IdDayOfWeek] = DATEPART(WEEKDAY, Tzdb.FromUtc(VDMR.[Date]))
					LEFT OUTER JOIN [dbo].[Mark] EDMark WITH (NOLOCK) ON Tzdb.AreSameSystemDates(EDMark.[Date], VDMR.[Date]) = 1
														AND EDMark.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest] 
														AND EDMark.[Type] ='ED'
														AND EDMark.[Date]> VDMR.[Date] 
														AND (SELECT COUNT(1)FROM [dbo].[Mark] M1 WITH (NOLOCK) WHERE M1.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]
																	AND M1.[Type] = 'ED' AND M1.[Id] != EDMark.[Id]
																	AND M1.[Date]> VDMR.[Date] AND M1.[Date]<EDMark.[Date])=0
					LEFT OUTER JOIN [dbo].[Mark] SDMark WITH (NOLOCK) ON Tzdb.AreSameSystemDates(SDMark.[Date], VDMR.[Date]) = 1
														AND SDMark.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]
														AND SDMark.[Type] = 'SD'
														AND SDMark.[Date]> VDMR.[Date]
														AND (SELECT COUNT(1) FROM [dbo].[Mark] M2 WITH (NOLOCK) WHERE M2.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]
																AND M2.[Type] = 'SD' AND M2.[Id] != SDMark.[Id]
																AND M2.[Date]> VDMR.[Date] AND M2.[Date]<SDMark.[Date])=0
					LEFT OUTER JOIN [dbo].[Mark] SMark WITH (NOLOCK) ON Tzdb.AreSameSystemDates(SMark.[Date], VDMR.[Date]) = 1
														AND SMark.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]
														AND SMark.[Type] = 'S'
														AND SMark.[Date]> VDMR.[Date] 
														AND (SELECT COUNT(1) FROM [dbo].[Mark] M3 WITH (NOLOCK) WHERE M3.[IdPersonOfInterest] = VDMR.[IdPersonOfInterest]
																AND M3.[Type] = 'S' AND M3.[Id] != SMark.[Id]
																AND M3.[Date]> VDMR.[Date] AND M3.[Date]<SMark.[Date])=0	

		WHERE	((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) and
					((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
					((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1))
				AND S.[Id] NOT IN (SELECT   PA.[IdPersonOfInterest]
									FROM    [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK)
									WHERE   VDMR.[Date] >= PA.[FromDate] AND (PA.[ToDate] IS NULL OR VDMR.[Date] < PA.[ToDate]))
		GROUP BY VDMR.[IdPersonOfInterest], S.[Name], S.[LastName], S.[Identifier]
		ORDER BY VDMR.[IdPersonOfInterest] DESC
	END
END
