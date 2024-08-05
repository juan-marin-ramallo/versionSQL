/****** Object:  Procedure [dbo].[GetActivityPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetActivityPointsOfInterest]
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@PersonOfInterestIds [sys].[varchar](MAX) = NULL
	,@PointOfInterestIds [sys].[varchar](MAX) = NULL
	,@UseAutomaticMarks [sys].[bit]
	,@IdUser [sys].[int] = NULL
	,@IncludeDaysNoVisits [sys].[bit] = 1
AS
BEGIN
	
	DECLARE @PointsOfInterestTheoricalHours TABLE
	(
		[IdPointOfInterest] [sys].[int],
		[TheoricalMinutes] [sys].[int]
	)

	INSERT INTO @PointsOfInterestTheoricalHours([IdPointOfInterest], [TheoricalMinutes])
	SELECT		RPOI.[IdPointOfInterest], SUM(ISNULL(RD.[TheoricalMinutes], 0))
	FROM		[dbo].[RouteGroup] RG WITH (NOLOCK)
				INNER JOIN [dbo].[RoutePointOfInterest] RPOI WITH (NOLOCK) ON RPOI.[IdRouteGroup] = RG.[Id] AND RPOI.[Deleted] = 0
				INNER JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RPOI.[Id] AND RD.[Disabled] = 0
	WHERE		RG.[Deleted] = 0
				--AND RPOI.[Deleted] = 0
				--AND RD.[Disabled] = 0
				AND RD.[RouteDate] BETWEEN @DateFrom AND @DateTo
	GROUP BY	RPOI.[IdPointOfInterest]
	
	IF @IncludeDaysNoVisits = 0 OR @UseAutomaticMarks = 0
	BEGIN

		SELECT		POIV.[IdPointOfInterest], POIV.[PointOfInterestName], POIV.[PointOfInterestIdentifier], POIV.[ElapsedTime],
					POITH.[TheoricalMinutes], POIV.[IdPersonOfInterest], POIV.[ActionDate]
		FROM		[dbo].PointsOfInterestVisitedDailyReport(@DateFrom, @DateTo, @PersonOfInterestIds, 
					@PointOfInterestIds, @UseAutomaticMarks, @IdUser) POIV
					LEFT OUTER JOIN @PointsOfInterestTheoricalHours POITH ON POITH.[IdPointOfInterest] = POIV.[IdPointOfInterest]
		ORDER BY	POIV.[PointOfInterestName], POIV.[IdPointOfInterest]

	END
	ELSE
	BEGIN
		DECLARE @DateFromAux [sys].[date] = Tzdb.FromUtc(@DateFrom)
		CREATE TABLE #AllPersonOfInterestDates
		(
			GroupedDateSystem [sys].[DATETIME], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50)
			, PersonOfInterestLastName [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50)
		)

		DECLARE @DateToTruncated [sys].[date]
		SET @DateToTruncated = Tzdb.FromUtc(@DateTo)

		WHILE @DateFromAux <= @DateToTruncated
		BEGIN

			INSERT INTO #AllPersonOfInterestDates(GroupedDateSystem, IdPersonOfInterest, PersonOfInterestName, PersonOfInterestLastName,
				PersonOfInterestIdentifier)
			SELECT DISTINCT @DateFromAux, P.[Id], P.[Name], P.[LastName], P.[Identifier]
			FROM [dbo].[PersonOfInterest] P WITH (NOLOCK)
				JOIN PersonOfInterestSchedule S WITH (NOLOCK) ON S.IdPersonOfInterest = P.Id
			WHERE P.[Deleted] = 0
				AND S.IdDayOfWeek = DATEPART(WEEKDAY, @DateFromAux)
				AND ((@PersonOfInterestIds IS NULL) OR (dbo.CheckValueInList(P.[Id], @PersonOfInterestIds) = 1))
        AND P.[Id] NOT IN (SELECT PA.[IdPersonOfInterest]
                          FROM    [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK)
                          WHERE   Tzdb.ToUtc(@DateFromAux) >= PA.[FromDate] AND (PA.[ToDate] IS NULL OR Tzdb.ToUtc(@DateFromAux) < PA.[ToDate]))

			SET @DateFromAux = DATEADD(DAY, 1, @DateFromAux)
		END
		
		SELECT		POIV.[IdPointOfInterest], POIV.[PointOfInterestName], POIV.[PointOfInterestIdentifier], POIV.[ElapsedTime],
					POITH.[TheoricalMinutes], POIV.[IdPersonOfInterest], POIV.[ActionDate]
		FROM		#AllPersonOfInterestDates AD
					LEFT JOIN [dbo].PointsOfInterestVisitedDailyReport(@DateFrom, @DateTo, @PersonOfInterestIds, 
						@PointOfInterestIds, @UseAutomaticMarks, @IdUser) POIV ON AD.[IdPersonOfInterest] = POIV.[IdPersonOfInterest]
						AND DATEDIFF(DAY, AD.[GroupedDateSystem], Tzdb.FromUtc(POIV.[ActionDate])) = 0
					LEFT OUTER JOIN @PointsOfInterestTheoricalHours POITH ON POITH.[IdPointOfInterest] = POIV.[IdPointOfInterest]
		ORDER BY	POIV.[PointOfInterestName], POIV.[IdPointOfInterest]

		DROP TABLE #AllPersonOfInterestDates
	END
END

-- OLD)
-- BEGIN
	
-- 	DECLARE @PointsOfInterestTheoricalHours TABLE
-- 	(
-- 		[IdPointOfInterest] [sys].[int],
-- 		[TheoricalMinutes] [sys].[int]
-- 	)

-- 	INSERT INTO @PointsOfInterestTheoricalHours([IdPointOfInterest], [TheoricalMinutes])
-- 	SELECT		RPOI.[IdPointOfInterest], SUM(ISNULL(RD.[TheoricalMinutes], 0))
-- 	FROM		[dbo].[RouteGroup] RG WITH (NOLOCK)
-- 				INNER JOIN [dbo].[RoutePointOfInterest] RPOI WITH (NOLOCK) ON RPOI.[IdRouteGroup] = RG.[Id] AND RPOI.[Deleted] = 0
-- 				INNER JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RPOI.[Id] AND RD.[Disabled] = 0
-- 	WHERE		RG.[Deleted] = 0
-- 				AND RPOI.[Deleted] = 0
-- 				AND RD.[Disabled] = 0
-- 				AND RD.[RouteDate] BETWEEN @DateFrom AND @DateTo
-- 	GROUP BY	RPOI.[IdPointOfInterest]
	
-- 	IF @IncludeDaysNoVisits = 0 OR @UseAutomaticMarks = 0
-- 	BEGIN

-- 		SELECT		POIV.[IdPointOfInterest], POIV.[PointOfInterestName], POIV.[PointOfInterestIdentifier], POIV.[ElapsedTime],
-- 					POITH.[TheoricalMinutes]
-- 		FROM		[dbo].PointsOfInterestVisitedDailyReport(@DateFrom, @DateTo, @PersonOfInterestIds, 
-- 					@PointOfInterestIds, @UseAutomaticMarks, @IdUser) POIV
-- 					LEFT OUTER JOIN @PointsOfInterestTheoricalHours POITH ON POITH.[IdPointOfInterest] = POIV.[IdPointOfInterest]
-- 		ORDER BY	POIV.[PointOfInterestName], POIV.[IdPointOfInterest]

-- 	END
-- 	ELSE
-- 	BEGIN
-- 		DECLARE @DateFromAux [sys].[date] = Tzdb.FromUtc(@DateFrom)
-- 		CREATE TABLE #AllPersonOfInterestDates
-- 		(
-- 			GroupedDate [sys].[DATETIME], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50)
-- 			, PersonOfInterestLastName [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50)
-- 		)

-- 		DECLARE @DateToTruncated [sys].[date]
-- 		SET @DateToTruncated = Tzdb.FromUtc(@DateTo)

-- 		WHILE @DateFromAux <= @DateToTruncated
-- 		BEGIN

-- 			INSERT INTO #AllPersonOfInterestDates(GroupedDate, IdPersonOfInterest, PersonOfInterestName, PersonOfInterestLastName,
-- 				PersonOfInterestIdentifier)
-- 			SELECT DISTINCT Tzdb.ToUtc(@DateFromAux), P.[Id], P.[Name], P.[LastName], P.[Identifier]
-- 			FROM [dbo].[PersonOfInterest] P
-- 				JOIN PersonOfInterestSchedule S ON S.IdPersonOfInterest = P.Id
-- 			WHERE P.[Deleted] = 0
-- 				AND S.IdDayOfWeek = DATEPART(WEEKDAY, @DateFromAux)
-- 				AND ((@PersonOfInterestIds IS NULL) OR (dbo.CheckValueInList(P.[Id], @PersonOfInterestIds) = 1))		

-- 			SET @DateFromAux = DATEADD(DAY, 1, @DateFromAux)
-- 		END
		
-- 		SELECT		POIV.[IdPointOfInterest], POIV.[PointOfInterestName], POIV.[PointOfInterestIdentifier], POIV.[ElapsedTime],
-- 					POITH.[TheoricalMinutes]
-- 		FROM		#AllPersonOfInterestDates AD
-- 					LEFT JOIN [dbo].PointsOfInterestVisitedDailyReport(@DateFrom, @DateTo, @PersonOfInterestIds, 
-- 						@PointOfInterestIds, @UseAutomaticMarks, @IdUser) POIV ON AD.[IdPersonOfInterest] = POIV.[IdPersonOfInterest]
-- 						AND Tzdb.AreSameSystemDates(AD.[GroupedDate], POIV.[ActionDate]) = 1
-- 					LEFT OUTER JOIN @PointsOfInterestTheoricalHours POITH ON POITH.[IdPointOfInterest] = POIV.[IdPointOfInterest]
-- 		ORDER BY	POIV.[PointOfInterestName], POIV.[IdPointOfInterest]

-- 		DROP TABLE #AllPersonOfInterestDates
-- 	END
-- END

-- -- OLD)
-- --DECLARE @DateFromAux [sys].[date] = Tzdb.FromUtc(@DateFrom)
-- --CREATE TABLE #AllPersonOfInterestDates
-- --(
-- --	GroupedDate [sys].[DATETIME], IdPersonOfInterest [sys].[int], PersonOfInterestName [sys].[varchar](50)
-- --	, PersonOfInterestLastName [sys].[varchar](50), PersonOfInterestIdentifier [sys].[varchar](50)
-- --)

-- --DECLARE @DateToTruncated [sys].[date]
-- --SET @DateToTruncated = Tzdb.FromUtc(@DateTo)

-- --WHILE @DateFromAux <= @DateToTruncated
-- --BEGIN

-- --	INSERT INTO #AllPersonOfInterestDates(GroupedDate, IdPersonOfInterest, PersonOfInterestName, PersonOfInterestLastName,
-- --		PersonOfInterestIdentifier)
-- --	SELECT DISTINCT Tzdb.ToUtc(@DateFromAux), P.[Id], P.[Name], P.[LastName], P.[Identifier]
-- --	FROM [dbo].[PersonOfInterest] P
-- --		JOIN PersonOfInterestSchedule S ON S.IdPersonOfInterest = P.Id
-- --	WHERE P.[Deleted] = 0
-- --		AND S.IdDayOfWeek = DATEPART(WEEKDAY, @DateFromAux)
-- --		AND ((@PersonOfInterestIds IS NULL) OR (dbo.CheckValueInList(P.[Id], @PersonOfInterestIds) = 1))		

-- --	SET @DateFromAux = DATEADD(DAY, 1, @DateFromAux)
-- --END
-- --IF @IncludeDaysNoVisits = 0 OR @UseAutomaticMarks = 0
-- --BEGIN

-- --	SELECT	[IdPointOfInterest], [PointOfInterestName], [PointOfInterestIdentifier], [ElapsedTime]
-- --	FROM	[dbo].PointsOfInterestVisitedDailyReport(@DateFrom, @DateTo, @PersonOfInterestIds, 
-- --			@PointOfInterestIds, @UseAutomaticMarks, @IdUser) POIV
-- --	ORDER BY [PointOfInterestName], [IdPointOfInterest]

-- --END
-- --ELSE
-- --BEGIN

-- --	SELECT	[IdPointOfInterest], [PointOfInterestName], [PointOfInterestIdentifier], [ElapsedTime]
-- --	FROM	#AllPersonOfInterestDates AD
-- --			LEFT JOIN [dbo].PointsOfInterestVisitedDailyReport(@DateFrom, @DateTo, @PersonOfInterestIds, 
-- --			@PointOfInterestIds, @UseAutomaticMarks, @IdUser) POIV ON AD.[IdPersonOfInterest] = POIV.[IdPersonOfInterest]
-- --			AND Tzdb.AreSameSystemDates(AD.[GroupedDate], POIV.[ActionDate]) = 1
-- --	ORDER BY [PointOfInterestName], [IdPointOfInterest]

-- --END
-- --DROP TABLE #AllPersonOfInterestDates
