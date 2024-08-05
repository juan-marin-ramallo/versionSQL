/****** Object:  Procedure [dbo].[GetManualWorkingHoursGroupByPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 16/10/2015
-- Description:	SP para GRAFICO DE REPORTES DE ACTIVIDADES DONDE SE MUESTRE LAS HORAS TRABAJADAS registradas de forma manual POR persona en determinado periodo
-- =============================================
CREATE PROCEDURE [dbo].[GetManualWorkingHoursGroupByPersonOfInterest]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@IdDepartments [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL	
	,@IdUser [sys].[int] = NULL
	,@OnlyScheduled [sys].[bit] = NULL
AS
BEGIN
	DECLARE @NewDateFrom [sys].[DATE]
    DECLARE @NewDateTo [sys].[DATE]
    
	SET @NewDateFrom = CAST(Tzdb.FromUtc(@DateFrom) AS [sys].[date])
	SET @NewDateTo = CAST(Tzdb.FromUtc(@DateTo) AS [sys].[date])

	SELECT	S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName,  S.[LastName] AS PersonOfInterestLastName,
			SUM(DATEDIFF(SECOND, '0:00:00', [POIV].[ElapsedTime])) AS ElapsedTimeInSeconds
	
	FROM	[dbo].[PointOfInterestManualVisited] POIV WITH (NOLOCK)
			INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
			INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]
	
	WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[CheckOutDate] IS NULL AND Tzdb.IsGreaterOrSameSystemDate(POIV.[CheckInDate], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate(POIV.[CheckInDate], @DateTo) = 1) 
				OR (CAST(Tzdb.FromUtc(POIV.[CheckInDate]) AS [sys].[date]) BETWEEN @NewDateFrom AND @NewDateTo) 
				OR (CAST(Tzdb.FromUtc(POIV.[CheckOutDate]) AS [sys].[date]) 
				BETWEEN @NewDateFrom AND @NewDateTo)) AND
			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))

	GROUP BY  S.[Id], S.[Name] ,  S.[LastName]
	ORDER BY ElapsedTimeInSeconds desc
    
	

END
