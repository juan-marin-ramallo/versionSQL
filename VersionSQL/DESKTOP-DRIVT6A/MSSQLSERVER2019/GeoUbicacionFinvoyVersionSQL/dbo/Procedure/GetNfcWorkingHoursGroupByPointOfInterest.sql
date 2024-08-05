/****** Object:  Procedure [dbo].[GetNfcWorkingHoursGroupByPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 17/01/2017
-- Description:	SP para GRAFICO DE REPORTES DE ACTIVIDADES DONDE SE MUESTRE LAS HORAS TRABAJADAS Y REGISTRADAS con tags NFC POR PUNTO EN UN PERIODO
-- =============================================
CREATE PROCEDURE [dbo].[GetNfcWorkingHoursGroupByPointOfInterest]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL	
	,@IdUser [sys].[int] = NULL
AS
BEGIN
	DECLARE @NewDateFrom [sys].[date]
    DECLARE @NewDateTo [sys].[date]
    
	SET @NewDateFrom = CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date])
	SET @NewDateTo = CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date])

	SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName,  P.[Identifier] AS PointOfInterestIdentifier,
			SUM(DATEDIFF(SECOND, '0:00:00', [POIV].[ElapsedTime])) AS ElapsedTimeInSeconds
	
	FROM	[dbo].[PointOfInterestMark] POIV		
			INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = POIV.[IdPointOfInterest]
			INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIV.[IdPersonOfInterest]
	
	WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[CheckOutDate] IS NULL AND Tzdb.IsGreaterOrSameSystemDate(POIV.[CheckInDate], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate(POIV.[CheckInDate], @DateTo) = 1) 
				OR (CAST(Tzdb.FromUtc(POIV.[CheckInDate]) AS [sys].[date]) BETWEEN @NewDateFrom AND @NewDateTo) 
				OR (CAST(Tzdb.FromUtc(POIV.[CheckOutDate]) AS [sys].[date]) 
				BETWEEN @NewDateFrom AND @NewDateTo)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  P.[Id], P.[Name], P.[Identifier]
	ORDER BY ElapsedTimeInSeconds desc
    
	

END
