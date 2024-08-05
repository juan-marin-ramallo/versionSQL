/****** Object:  Procedure [dbo].[GetWorkingHoursGroupByPointOfInterestConfirmed]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gaston Legnani
-- Create date: 16/10/2015
-- Description:	SP para GRAFICO DE REPORTES DE ACTIVIDADES DONDE SE MUESTRE LAS HORAS TRABAJADAS POR PUNTO EN UN PERIODO
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkingHoursGroupByPointOfInterestConfirmed]

	 @DateFrom [sys].[datetime] = NULL
	,@DateTo [sys].[datetime] = NULL
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL	
	,@IdUser [sys].[int] = NULL
	,@OnlyScheduled [sys].[bit] = NULL
	,@OnlyConfirmed [sys].[bit] = NULL
AS
BEGIN

	DECLARE @DateFromAux [sys].[date] = Tzdb.FromUtc(@DateFrom)
	DECLARE @DateToTruncated [sys].[date]
	SET @DateToTruncated = Tzdb.FromUtc(@DateTo)

	DECLARE @PointsOfInterestActivityDone TABLE
	(
		 [IdPersonOfInterest] [sys].[int]
		,[PersonOfInterestName] [sys].[varchar](50)
		,[PersonOfInterestLastName] [sys].[varchar](50)
		,[ActionDate] [sys].[datetime]
		,[IdDepartment] [sys].[INT]
		,[Latitude] [sys].[decimal](25,20)
		,[Longitude] [sys].[decimal](25,20)
		,[Address] [sys].[varchar](250)
		,[IdPointOfInterest] [sys].[int]
		,[PointOfInterestName] [sys].[varchar](100)
		,[PointOfInterestIdentifier] [sys].[varchar](50)
		,[AutomaticValue] [sys].[int]
		,[Reason] [sys].[varchar](100)
		,[ConfirmedVisit] [sys].[bit]
		,[Number] [sys].[int]
	)

	;WITH TablePartition AS 
	( 
		SELECT	[IdPersonOfInterest], [PersonOfInterestName], 
				[PersonOfInterestLastName], [ActionDate], [IdDepartment],	[Latitude], [Longitude], [Address],
				[IdPointOfInterest], [PointOfInterestName], [PointOfInterestIdentifier],
				[AutomaticValue], [Reason], [ConfirmedVisit],
				 ROW_NUMBER() OVER 
				 ( 
					 PARTITION BY IdPersonOfInterest, IdPointOfInterest, CAST(Tzdb.FromUtc(ActionDate) AS [sys].[date])
					 ORDER BY AutomaticValue 
				 ) AS Number 
		FROM [dbo].PointsOfInterestActivityDone(@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest, 
			@IdPointsOfInterest, @IdUser) POIV
	) 

	INSERT INTO @PointsOfInterestActivityDone
	(
		 [IdPersonOfInterest], [PersonOfInterestName],[PersonOfInterestLastName]
		,[ActionDate], [IdDepartment], [Latitude], [Longitude], [Address], [IdPointOfInterest], [PointOfInterestName]
		,[PointOfInterestIdentifier], [AutomaticValue], [Reason],[ConfirmedVisit], [Number]
	)
	SELECT * FROM TablePartition 

	IF @OnlyScheduled = 1
	BEGIN
		CREATE TABLE #AllPersonOfInterestDatesAux
		(
			GroupedDate [sys].[DATETIME], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50)
			, PersonOfInterestLastName [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50)
		)

		WHILE @DateFromAux <= @DateToTruncated 
		BEGIN
			INSERT INTO #AllPersonOfInterestDatesAux(GroupedDate, IdPersonOfInterest, PersonOfInterestName, 
						PersonOfInterestLastName, PersonOfInterestIdentifier)
			SELECT DISTINCT Tzdb.ToUtc(@DateFromAux), P.[Id], P.[Name], P.[LastName], P.[Identifier]
			FROM [dbo].[PersonOfInterest] P
				JOIN [dbo].[PersonOfInterestSchedule] S ON S.[IdPersonOfInterest] = P.[Id]
			WHERE S.[IdDayOfWeek] = DATEPART(WEEKDAY, @DateFromAux)
				AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1))		

			SET @DateFromAux = DATEADD(DAY, 1, @DateFromAux)
		END

		SELECT a.PointOfInterestId, a.PointOfInterestName, a.PointOfInterestIdentifier, 
		SUM(DATEDIFF(SECOND, '0:00:00', a.ElapsedTimeInMilliSeconds)) AS ElapsedTimeInSeconds
		FROM

		(SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName,  P.[Identifier] AS PointOfInterestIdentifier,
				 [POIV].[ElapsedTime] AS ElapsedTimeInMilliSeconds

		FROM	#AllPersonOfInterestDatesAux D
				INNER JOIN [dbo].[PointOfInterestVisited] POIV ON POIV.[IdPersonOfInterest] = D.[IdPersonOfInterest] 
								AND Tzdb.AreSameSystemDates(POIV.[LocationInDate], D.[GroupedDate]) = 1
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = POIV.[IdPointOfInterest]
				LEFT OUTER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIV.[IdPersonOfInterest]
				LEFT OUTER JOIN	@PointsOfInterestActivityDone POID ON POIV.[IdPersonOfInterest] = POID.[IdPersonOfInterest]
								AND POIV.[IdPointOfInterest] = POID.[IdPointOfInterest] 
								AND (
									(POID.[ActionDate] BETWEEN POIV.[LocationInDate] AND POIV.[LocationOutDate]) 
								)

		WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL AND POIV.[LocationInDate] >= @DateFrom AND POIV.[LocationInDate] <= @DateTo) 
					OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo) 
					OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)) AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1
				AND
				((@OnlyConfirmed IS NULL AND POID.[ConfirmedVisit] IS NULL) --SOLO SIN CONFIRMAR
				OR (@OnlyConfirmed IS NOT NULL AND POID.[ConfirmedVisit] IS NOT NULL)) --SOLO CONFIRMADOS

		GROUP BY  P.[Id], P.[Name], P.[Identifier], [POIV].[ElapsedTime])a

		group by a.PointOfInterestId, a.PointOfInterestName, a.PointOfInterestIdentifier
		ORDER BY ElapsedTimeInSeconds desc
 
		DROP TABLE #AllPersonOfInterestDatesAux

	END
	ELSE
	BEGIN

		SELECT a.PointOfInterestId, a.PointOfInterestName, a.PointOfInterestIdentifier, 
		SUM(DATEDIFF(SECOND, '0:00:00', a.ElapsedTimeInMilliSeconds)) AS ElapsedTimeInSeconds
		FROM

		(SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName,  P.[Identifier] AS PointOfInterestIdentifier,
				 [POIV].[ElapsedTime] AS ElapsedTimeInMilliSeconds
	
		FROM	[dbo].[PointOfInterestVisited] POIV		
				INNER JOIN [dbo].[PointOfInterest] P ON P.[Id] = POIV.[IdPointOfInterest]
				LEFT OUTER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = POIV.[IdPersonOfInterest]
				LEFT OUTER JOIN	@PointsOfInterestActivityDone POID ON POIV.[IdPersonOfInterest] = POID.[IdPersonOfInterest]
									AND POIV.[IdPointOfInterest] = POID.[IdPointOfInterest] 
									AND (
										(POID.[ActionDate] BETWEEN POIV.[LocationInDate] AND POIV.[LocationOutDate]) 
									)

		WHERE	POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL AND POIV.[LocationInDate] >= @DateFrom AND POIV.[LocationInDate] <= @DateTo) 
						OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo) 
						OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)) AND
				((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
				((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				[dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1 
				AND
				((@OnlyConfirmed IS NULL AND POID.[ConfirmedVisit] IS NULL) --SOLO SIN CONFIRMAR
				OR (@OnlyConfirmed IS NOT NULL AND POID.[ConfirmedVisit] IS NOT NULL)) --SOLO CONFIRMADOS

		GROUP BY  P.[Id], P.[Name], P.[Identifier], [POIV].[ElapsedTime])a

		group by a.PointOfInterestId, a.PointOfInterestName, a.PointOfInterestIdentifier
		ORDER BY ElapsedTimeInSeconds desc
    
    
	END

END
