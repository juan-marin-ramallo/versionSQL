/****** Object:  Procedure [dbo].[GetWorkingHoursGroupByPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 16/10/2015
-- Description:	SP para GRAFICO DE REPORTES DE ACTIVIDADES DONDE SE MUESTRE LAS HORAS TRABAJADAS POR persona en determinado periodo
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkingHoursGroupByPersonOfInterest]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@IdDepartments [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL	
	,@IdUser [sys].[int] = NULL
	,@OnlyScheduled [sys].[bit] = NULL
AS
BEGIN

	DECLARE @DateFromAux [sys].[datetime] = @DateFrom
	IF @OnlyScheduled = 1
	BEGIN
		CREATE TABLE AllPersonOfInterestDatesAux2
		(
			GroupedDate [sys].[DATETIME], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50)
			, PersonOfInterestLastName [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50)
		)

		WHILE Tzdb.IsLowerOrSameSystemDate(@DateFromAux, @DateTo) = 1
		BEGIN
			INSERT INTO AllPersonOfInterestDatesAux2(GroupedDate, IdPersonOfInterest, PersonOfInterestName, 
						PersonOfInterestLastName, PersonOfInterestIdentifier)
			SELECT DISTINCT @DateFromAux, P.[Id], P.[Name], P.[LastName], P.[Identifier]
			FROM [dbo].[PersonOfInterest] P WITH (NOLOCK)
				JOIN [dbo].[PersonOfInterestSchedule] S WITH (NOLOCK) ON S.[IdPersonOfInterest] = P.[Id]
			WHERE S.[IdDayOfWeek] = DATEPART(WEEKDAY, Tzdb.FromUtc(@DateFromAux))
				AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1))		

			SET @DateFromAux = DATEADD(day, 1, @DateFromAux)
		END

		SELECT	S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName,  S.[LastName] AS PersonOfInterestLastName,
				SUM(DATEDIFF(SECOND, '0:00:00', [POIV].[ElapsedTime])) AS ElapsedTimeInSeconds
		FROM	AllPersonOfInterestDatesAux2 D
				INNER JOIN [dbo].[PointOfInterestVisited] POIV WITH (NOLOCK) ON POIV.[IdPersonOfInterest] = D.[IdPersonOfInterest] 
								AND Tzdb.AreSameSystemDates(POIV.[LocationInDate], D.[GroupedDate]) = 1
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
				LEFT OUTER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]
		WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL AND POIV.[LocationInDate] >= @DateFrom AND POIV.[LocationInDate] <= @DateTo) 
					OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo) 
					OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)) AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1

		GROUP BY  S.[Id], S.[Name] ,  S.[LastName]
		ORDER BY ElapsedTimeInSeconds desc
 
		DROP TABLE AllPersonOfInterestDatesAux2

	END
	ELSE
	BEGIN

		SELECT	S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName,  S.[LastName] AS PersonOfInterestLastName,
				SUM(DATEDIFF(SECOND, '0:00:00', [POIV].[ElapsedTime])) AS ElapsedTimeInSeconds
		FROM	[dbo].[PointOfInterestVisited] POIV WITH (NOLOCK)
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
				LEFT OUTER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]
		WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL AND POIV.[LocationInDate] >= @DateFrom AND POIV.[LocationInDate] <= @DateTo) 
					OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo) 
					OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)) AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1

		GROUP BY  S.[Id], S.[Name] ,  S.[LastName]
		ORDER BY ElapsedTimeInSeconds desc
    
	END

END
