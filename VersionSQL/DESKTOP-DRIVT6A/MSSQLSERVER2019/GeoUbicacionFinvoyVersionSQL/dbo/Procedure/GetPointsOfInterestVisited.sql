/****** Object:  Procedure [dbo].[GetPointsOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 17/10/2012
-- Description:	SP para obtener los puntos de interés visitados
-- =============================================
CREATE PROCEDURE [dbo].[GetPointsOfInterestVisited]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL	
	,@IdUser [sys].[int] = NULL
	,@OnlyScheduled [sys].[bit] = NULL
)
AS
BEGIN
	/*
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
	)

	;WITH TablePartition AS 
	( 
		SELECT	[IdPersonOfInterest], [PersonOfInterestName], 
				[PersonOfInterestLastName], [ActionDate], [IdDepartment],	[Latitude], [Longitude], [Address],
				[IdPointOfInterest], [PointOfInterestName], [PointOfInterestIdentifier],
				[AutomaticValue], [Reason], [ConfirmedVisit]
		FROM 	[dbo].PointsOfInterestActivityDone(@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest, 
					@IdPointsOfInterest, @IdUser) POIV
	) 

	INSERT INTO @PointsOfInterestActivityDone
	(
		 [IdPersonOfInterest], [PersonOfInterestName],[PersonOfInterestLastName]
		,[ActionDate], [IdDepartment], [Latitude], [Longitude], [Address], [IdPointOfInterest], [PointOfInterestName]
		,[PointOfInterestIdentifier], [AutomaticValue], [Reason],[ConfirmedVisit]
	)
	SELECT 	[IdPersonOfInterest], [PersonOfInterestName],[PersonOfInterestLastName]
			,[ActionDate], [IdDepartment], [Latitude], [Longitude], [Address], [IdPointOfInterest], [PointOfInterestName]
			,[PointOfInterestIdentifier], [AutomaticValue], [Reason],[ConfirmedVisit]
	FROM 	TablePartition 
	*/
	SET NOCOUNT ON;

	IF @OnlyScheduled = 1
	BEGIN
		DECLARE @DateFromSystem [sys].[datetime] = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(@DateFrom)), 0)
		DECLARE @DateToSystem [sys].[datetime] = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(@DateTo)), 0)

		CREATE TABLE #AllPersonOfInterestDates
		(
			GroupedDate [sys].[DATETIME], IdPersonOfInterest [sys].[int]
		)

		WHILE @DateFromSystem <= @DateToSystem
		BEGIN
			INSERT INTO #AllPersonOfInterestDates(GroupedDate, IdPersonOfInterest)
			SELECT DISTINCT @DateFromSystem, P.[Id]
			FROM [dbo].[PersonOfInterest] P
			WHERE P.[Id] IN (SELECT S.[IdPersonOfInterest] FROM [dbo].[PersonOfInterestSchedule] S WITH (NOLOCK) WHERE S.[IdDayOfWeek] = DATEPART(WEEKDAY, @DateFromSystem))
				AND ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1))		

			SET @DateFromSystem = DATEADD(DAY, 1, @DateFromSystem)
		END

		;WITH vPointsVisited AS
		(
			SELECT	POIV.[Id], POIV.[IdLocationIn], POIV.[LocationInDate], POIV.[IdLocationOut], 
					POIV.[LocationOutDate], POIV.[IdPointOfInterest], POIV.[IdPersonOfInterest], POIV.[ElapsedTime],
					POID.[ConfirmedVisit],
					DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(POIV.[LocationInDate])), 0) AS LocationInDateSystem
			FROM	[dbo].[PointOfInterestVisited] POIV WITH (NOLOCK)
					LEFT OUTER JOIN	[dbo].PointsOfInterestActivityDoneSimplified(@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest, 
						@IdPointsOfInterest, @IdUser) POID ON POID.[IdPersonOfInterest] = POIV.[IdPersonOfInterest]
							AND POID.[IdPointOfInterest] = POIV.[IdPointOfInterest]
							AND POID.[ActionDate] BETWEEN POIV.[LocationInDate] AND POIV.[LocationOutDate]
			WHERE	(POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL AND POIV.[LocationInDate] >= @DateFrom AND POIV.[LocationInDate] <= @DateTo) 
						OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo) 
						OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)))
					AND [dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1
					AND EXISTS (SELECT	1
								FROM	#AllPersonOfInterestDates D
								WHERE	D.[IdPersonOfInterest] = POIV.[IdPersonOfInterest]
										AND DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(POIV.[LocationInDate])), 0) = D.[GroupedDate])
		)
		,vPoints AS
		(
			SELECT	P.[Id], P.[Name], P.[Latitude], P.[Longitude], P.[Identifier], P.[Address], P.[IdDepartment], P.[FatherId], P.[GrandfatherId]
			FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
			WHERE	((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1) AND
						(dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
		)
		,vPersons AS
		(
			SELECT	S.[Id], S.[Name], S.[LastName], S.[MobileIMEI], S.[MobilePhoneNumber], S.[Identifier]
			FROM	[dbo].[PersonOfInterest] S WITH (NOLOCK)
			WHERE	((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
					((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
					((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1) AND
						(dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))
		)

		SELECT	POIV.[Id] as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, [IdLocationIn], POIV.[LocationInDate], [IdLocationOut], 
				POIV.[LocationOutDate], POIV.[IdPointOfInterest], P.[Name] AS PointOfInterestName, [ElapsedTime],
				P.[Latitude], P.[Longitude], P.[Identifier] AS PointOfInterestIdentifier, S.[MobileIMEI] AS PersonOfInterestIMEI,
				S.[MobilePhoneNumber] AS PersonOfInterestMobilePhoneNumber, S.[Identifier] AS PersonOfInterestIdentifier,
				DEP.[Id] AS DepartmentId, DEP.[Name] AS DepartmentName, P.[Address] AS PointOfInterestAddress,
				POI1.[Id] AS HierarchyLevel1Id, POI1.[Name] AS HierarchyLevel1Name,
				POI2.[Id] AS HierarchyLevel2Id, POI2.[Name] AS HierarchyLevel2Name, POIV.[ConfirmedVisit] AS ConfirmedVisit

		FROM	vPointsVisited POIV WITH (NOLOCK) 
				INNER JOIN vPoints P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
				INNER JOIN vPersons S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]
				LEFT OUTER JOIN [dbo].[Department] DEP WITH (NOLOCK) ON DEP.[Id] = P.[IdDepartment]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] POI1 WITH (NOLOCK) ON POI1.[Id] = P.[GrandfatherId]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] POI2 WITH (NOLOCK) ON POI2.[Id] = P.[FatherId]
				--LEFT OUTER JOIN	@PointsOfInterestActivityDone POID ON POIV.[IdPersonOfInterest] = POID.[IdPersonOfInterest]
				--				AND POIV.[IdPointOfInterest] = POID.[IdPointOfInterest] 
				--				AND POID.[ActionDate] BETWEEN POIV.[LocationInDate] AND POIV.[LocationOutDate]

--		WHERE	EXISTS (SELECT	1
--						FROM	#AllPersonOfInterestDates D
--						WHERE	D.[IdPersonOfInterest] = POIV.[IdPersonOfInterest]
--								--AND Tzdb.AreSameSystemDates(POIV.[LocationInDate], D.[GroupedDate]) = 1)
--								AND POIV.[LocationInDateSystem] = D.[GroupedDate])
--								--AND DATEDIFF(DAY, Tzdb.FromUtc(POIV.[LocationInDate]), Tzdb.FromUtc(D.[GroupedDate])) = 0)

		GROUP BY	POIV.[Id], S.[Id], S.[Name], S.[LastName], [IdLocationIn], POIV.[LocationInDate], [IdLocationOut], POIV.[LocationOutDate], 
					POIV.[IdPointOfInterest], P.[Name], [ElapsedTime], P.[Latitude], P.[Longitude], P.[Identifier], 
					S.[MobileIMEI], S.[MobilePhoneNumber],  S.[Identifier], P.[Address], DEP.[Id], DEP.[Name],
					POI1.[Id], POI1.[Name], POI2.[Id], POI2.[Name], POIV.[ConfirmedVisit] 

		ORDER BY IdPointOfInterestVisited desc

		DROP TABLE #AllPersonOfInterestDates
 
	END
	ELSE
	BEGIN
		;WITH vPointsVisited AS
		(
			SELECT	POIV.[Id], POIV.[IdLocationIn], POIV.[LocationInDate], POIV.[IdLocationOut], 
					POIV.[LocationOutDate], POIV.[IdPointOfInterest], POIV.[IdPersonOfInterest], POIV.[ElapsedTime],
					POID.[ConfirmedVisit]
			FROM	[dbo].[PointOfInterestVisited] POIV WITH (NOLOCK)
					LEFT OUTER JOIN	[dbo].PointsOfInterestActivityDoneSimplified(@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest, 
						@IdPointsOfInterest, @IdUser) POID ON POID.[IdPersonOfInterest] = POIV.[IdPersonOfInterest]
							AND POID.[IdPointOfInterest] = POIV.[IdPointOfInterest]
							AND POID.[ActionDate] BETWEEN POIV.[LocationInDate] AND POIV.[LocationOutDate]
			WHERE	(POIV.DeletedByNotVisited = 0 AND ((POIV.[LocationOutDate] IS NULL AND POIV.[LocationInDate] >= @DateFrom AND POIV.[LocationInDate] <= @DateTo) 
						OR (POIV.[LocationInDate] BETWEEN @DateFrom AND @DateTo) 
						OR (POIV.[LocationOutDate] BETWEEN @DateFrom AND @DateTo)))
					AND [dbo].IsVisitedLocationInPointHourWindow(POIV.[IdPointOfInterest], POIV.[LocationInDate], POIV.[LocationOutDate]) = 1	
		)
		,vPoints AS
		(
			SELECT	P.[Id], P.[Name], P.[Latitude], P.[Longitude], P.[Identifier], P.[Address], P.[IdDepartment], P.[FatherId], P.[GrandfatherId]
			FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
			WHERE	((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1) AND
						(dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))
		)
		,vPersons AS
		(
			SELECT	S.[Id], S.[Name], S.[LastName], S.[MobileIMEI], S.[MobilePhoneNumber], S.[Identifier]
			FROM	[dbo].[PersonOfInterest] S WITH (NOLOCK)
			WHERE	((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
					((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
					((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
					((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1) AND
						(dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))
		)
	
		SELECT	POIV.[Id] as IdPointOfInterestVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName, 
				S.[LastName] AS PersonOfInterestLastName, [IdLocationIn], POIV.[LocationInDate], [IdLocationOut], 
				POIV.[LocationOutDate], POIV.[IdPointOfInterest], P.[Name] AS PointOfInterestName, [ElapsedTime],
				P.[Latitude], P.[Longitude], P.[Identifier] AS PointOfInterestIdentifier, S.[MobileIMEI] AS PersonOfInterestIMEI,
				S.[MobilePhoneNumber] AS PersonOfInterestMobilePhoneNumber, S.[Identifier] AS PersonOfInterestIdentifier,
				DEP.[Id] AS DepartmentId, DEP.[Name] AS DepartmentName, P.[Address] AS PointOfInterestAddress,
				POI1.[Id] AS HierarchyLevel1Id, POI1.[Name] AS HierarchyLevel1Name,
				POI2.[Id] AS HierarchyLevel2Id, POI2.[Name] AS HierarchyLevel2Name, POIV.[ConfirmedVisit] AS ConfirmedVisit

		FROM	vPointsVisited POIV WITH (NOLOCK)
				INNER JOIN vPoints P WITH (NOLOCK) ON P.[Id] = POIV.[IdPointOfInterest]
				INNER JOIN vPersons S WITH (NOLOCK) ON S.[Id] = POIV.[IdPersonOfInterest]
				LEFT OUTER JOIN [dbo].[Department] DEP WITH (NOLOCK) ON DEP.[Id] = P.[IdDepartment]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] POI1 WITH (NOLOCK) ON POI1.[Id] = P.[GrandfatherId]
				LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] POI2 WITH (NOLOCK) ON POI2.[Id] = P.[FatherId]
				--LEFT OUTER JOIN	@PointsOfInterestActivityDone POID ON POIV.[IdPersonOfInterest] = POID.[IdPersonOfInterest]
				--				AND POIV.[IdPointOfInterest] = POID.[IdPointOfInterest] 
				--				AND POID.[ActionDate] BETWEEN POIV.[LocationInDate] AND POIV.[LocationOutDate]

		GROUP BY	POIV.[Id], S.[Id], S.[Name], S.[LastName], [IdLocationIn], POIV.[LocationInDate], [IdLocationOut], POIV.[LocationOutDate], 
					POIV.[IdPointOfInterest], P.[Name], [ElapsedTime], P.[Latitude], P.[Identifier], P.[Longitude], S.[MobileIMEI], 
					S.[MobilePhoneNumber], S.[Identifier], P.[Address], DEP.[Id], DEP.[Name],
					POI1.[Id], POI1.[Name], POI2.[Id], POI2.[Name], POIV.[ConfirmedVisit]

		ORDER BY IdPointOfInterestVisited desc
	END

END
