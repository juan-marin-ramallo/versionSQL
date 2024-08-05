/****** Object:  Procedure [dbo].[ProcessPointsOfInterestVisitedExits]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 22/10/2014
-- Description:	SP para procesar los puntos de interes visitados sin salida
-- =============================================
CREATE PROCEDURE [dbo].[ProcessPointsOfInterestVisitedExits]
(
	 @DateTo [sys].[datetime] = NULL
	,@IdPersonOfInterest [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
    DECLARE @DateToSystemTruncated [sys].[datetime]
	DECLARE @DeleteId [dbo].[IdTableType] 

	SET @Now = GETUTCDATE()
    SET @DateToSystemTruncated = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(ISNULL(@DateTo, @Now))), 0)

    DECLARE @PointsOfInterestVisitedWithoutExit TABLE
	(
		Id [sys].[int] NOT NULL,
		IdLocationIn [sys].[int] NOT NULL,
		LocationInDate [sys].[datetime] NOT NULL,
		IdPersonOfInterest [sys].[int] NULL,
		IdPointOfInterest [sys].[int] NULL,
		[LocationInDateSystemTruncated] [sys].[datetime] NOT NULL
	)

    ;WITH vPointsVisitedWithoutExit([Id], [IdLocationIn], [LocationInDate], [LocationInDateSystemTruncated],
                                    [IdPersonOfInterest], [IdPointOfInterest]) AS
    (
        SELECT  PV.Id, PV.IdLocationIn, PV.LocationInDate,
                DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(PV.LocationInDate)), 0) AS LocationInDateSystemTruncated,
                PV.[IdPersonOfInterest], PV.[IdPointOfInterest]
        FROM	[dbo].[PointOfInterestVisited] PV WITH (NOLOCK)
        WHERE	PV.IdLocationOut IS NULL
                AND ((@IdPersonOfInterest IS NULL) OR (PV.[IdPersonOfInterest] = @IdPersonOfInterest))
    )

	INSERT INTO @PointsOfInterestVisitedWithoutExit(Id, IdLocationIn, LocationInDate, IdPersonOfInterest, IdPointOfInterest, [LocationInDateSystemTruncated])
	SELECT	PV.Id, PV.IdLocationIn, PV.LocationInDate, PV.[IdPersonOfInterest], PV.[IdPointOfInterest], [LocationInDateSystemTruncated]
	FROM	vPointsVisitedWithoutExit PV WITH (NOLOCK)
	WHERE	PV.[LocationInDateSystemTruncated] < @DateToSystemTruncated

	IF EXISTS (SELECT 1 FROM @PointsOfInterestVisitedWithoutExit)
	BEGIN
		DECLARE @LocationsIn TABLE
		(
			Id [sys].[int] NOT NULL,
			IdPersonOfInterest [sys].[int] NOT NULL,
			Date [sys].[datetime] NOT NULL,
			DateSystemTruncated [sys].[datetime] NOT NULL
		)

		;WITH 
		vPoisNoExitMinDatePerson(IdPersonOfInterest, MinDate)AS
		(
			SELECT IdPersonOfInterest, MIN(LocationInDate) AS MinDate
			FROM @PointsOfInterestVisitedWithoutExit
			GROUP BY IdPersonOfInterest
		),
		vLocationsIn([Id], [IdPersonOfInterest], [Date], [DateSystemTruncated]) AS
		(
			SELECT	L.[Id], L.[IdPersonOfInterest], L.[Date], 
					DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(L.[Date])), 0) AS DateSystemTruncated
					
			FROM	[dbo].[Location] L WITH (NOLOCK)
				INNER JOIN vPoisNoExitMinDatePerson	PV ON L.[IdPersonOfInterest] = PV.[IdPersonOfInterest] AND L.Date >= PV.MinDate
		),
		vLocationsMaxPartitioned([Id], [IdPersonOfInterest], [Date], [DateSystemTruncated], RowNumber) AS
		(
			SELECT	L.[Id], L.[IdPersonOfInterest], L.[Date], L.DateSystemTruncated
					, ROW_NUMBER() OVER (PARTITION BY L.IdPersonOfInterest, L.DateSystemTruncated ORDER BY L.Date DESC) AS RowNumber
			FROM	vLocationsIn L
		)
		INSERT INTO @LocationsIn(Id, IdPersonOfInterest, Date, DateSystemTruncated)
		SELECT	[Id], [IdPersonOfInterest], [Date], DateSystemTruncated
		FROM	vLocationsMaxPartitioned WITH (NOLOCK)
		WHERE	RowNumber = 1 AND [DateSystemTruncated] < @DateToSystemTruncated

		DECLARE @Points TABLE
		(
			Id [sys].[int] NOT NULL,
			MinElapsedTimeForVisit [sys].[int] NOT NULL
		)

		INSERT INTO @Points(Id, MinElapsedTimeForVisit)
		SELECT	[Id], [MinElapsedTimeForVisit]
		FROM	[dbo].[PointOfInterest] WITH (NOLOCK)
		WHERE	[Id] IN (SELECT [IdPointOfInterest] FROM @PointsOfInterestVisitedWithoutExit)
		
		UPDATE	PV
		SET		PV.[IdLocationOut] = L.[Id],
				PV.[LocationOutDate] = L.[Date],
				PV.[ElapsedTime]  = DATEADD(SS, DATEDIFF(SS, PVWE.[LocationInDate], L.[Date]), 0),
				PV.[ClosedByChangeOfDay] = 1
		FROM    [dbo].[PointOfInterestVisited] AS PV
				INNER JOIN @PointsOfInterestVisitedWithoutExit AS PVWE ON PVWE.[Id] = PV.[Id]
				INNER JOIN @LocationsIn AS L ON L.[IdPersonOfInterest] = PVWE.[IdPersonOfInterest] AND L.DateSystemTruncated = PVWE.[LocationInDateSystemTruncated]

		-- Deletes closed by change of day whose elapsed time is less than min configured in points of interest
		INSERT INTO @DeleteId (Id)
		SELECT PV.Id
		FROM [dbo].[PointOfInterestVisited] PV
				INNER JOIN @Points P ON P.[Id] = PV.[IdPointOfInterest] AND DATEDIFF(MI, PV.[LocationInDate], PV.[LocationOutDate]) < P.[MinElapsedTimeForVisit]
				
		DECLARE @CursorId [sys].[int]
		DECLARE CUR_IDS CURSOR FAST_FORWARD FOR
			SELECT Id
			FROM   @DeleteId
			ORDER BY Id
 
		OPEN CUR_IDS
		FETCH NEXT FROM CUR_IDS INTO @CursorId
 
		WHILE @@FETCH_STATUS = 0
		BEGIN
		EXEC [dbo].[DeletePointsOfInterestActivity]
					@AutomaticValue = 1
				,@IdPointOfInterestVisited = @CursorId
				,@IdPointOfInterestManualVisited = NULL

			FETCH NEXT FROM CUR_IDS INTO @CursorId
		END
		CLOSE CUR_IDS
		DEALLOCATE CUR_IDS

		DELETE	PV
		FROM	@DeleteId DId
			INNER JOIN [dbo].[PointOfInterestVisited] PV ON PV.Id = DId.Id
	END
END

-- OLD)
-- BEGIN
-- 	DECLARE @Now [sys].[datetime]
-- 	SET @Now = GETUTCDATE()

-- 	DECLARE @PointsOfInterestVisitedWithoutExit TABLE
-- 	(
-- 		Id [sys].[int] NOT NULL,
-- 		IdLocationIn [sys].[int] NOT NULL,
-- 		LocationInDate [sys].[datetime] NOT NULL,
-- 		IdPersonOfInterest [sys].[int] NULL,
-- 		IdPointOfInterest [sys].[int] NULL
-- 	)

-- 	INSERT INTO @PointsOfInterestVisitedWithoutExit(Id, IdLocationIn, LocationInDate, IdPersonOfInterest, IdPointOfInterest)
-- 	SELECT	PV.Id, PV.IdLocationIn, PV.LocationInDate, PV.[IdPersonOfInterest], PV.[IdPointOfInterest]
-- 	FROM	[dbo].[PointOfInterestVisited] PV WITH (NOLOCK)
-- 	WHERE	PV.IdLocationOut IS NULL AND Tzdb.IsLowerSystemDate(PV.LocationInDate, ISNULL(@DateTo, @Now)) = 1
-- 			AND ((@IdPersonOfInterest IS NULL) OR (PV.[IdPersonOfInterest] = @IdPersonOfInterest))

-- 	IF EXISTS (SELECT 1 FROM @PointsOfInterestVisitedWithoutExit)
-- 	BEGIN
-- 		DECLARE @LocationsIn TABLE
-- 		(
-- 			Id [sys].[int] NOT NULL,
-- 			IdPersonOfInterest [sys].[int] NOT NULL,
-- 			Date [sys].[datetime] NOT NULL
-- 		)

-- 		INSERT INTO @LocationsIn(Id, IdPersonOfInterest, Date)
-- 		SELECT	[Id], [IdPersonOfInterest], [Date]
-- 		FROM	[dbo].[Location] WITH (NOLOCK)
-- 		WHERE	[IdPersonOfInterest] IN (SELECT [IdPersonOfInterest] FROM @PointsOfInterestVisitedWithoutExit)
-- 				AND Tzdb.IsLowerSystemDate([Date], ISNULL(@DateTo, @Now)) = 1

-- 		DECLARE @Points TABLE
-- 		(
-- 			Id [sys].[int] NOT NULL,
-- 			MinElapsedTimeForVisit [sys].[int] NOT NULL
-- 		)

-- 		INSERT INTO @Points(Id, MinElapsedTimeForVisit)
-- 		SELECT	[Id], [MinElapsedTimeForVisit]
-- 		FROM	[dbo].[PointOfInterest] WITH (NOLOCK)
-- 		WHERE	[Id] IN (SELECT [IdPointOfInterest] FROM @PointsOfInterestVisitedWithoutExit)

-- 		UPDATE	PV
-- 		SET		PV.[IdLocationOut] = L.[Id],
-- 				PV.[LocationOutDate] = L.[Date],
-- 				PV.[ElapsedTime]  = DATEADD(SS, DATEDIFF(SS, PVWE.[LocationInDate], L.[Date]), 0),
-- 				PV.[ClosedByChangeOfDay] = 1
-- 		FROM    [dbo].[PointOfInterestVisited] AS PV
-- 				INNER JOIN @PointsOfInterestVisitedWithoutExit AS PVWE ON PVWE.[Id] = PV.[Id]
-- 				INNER JOIN @LocationsIn AS L ON L.[Id] = (SELECT MAX([Id]) FROM @LocationsIn WHERE [IdPersonOfInterest] = PVWE.[IdPersonOfInterest] AND Tzdb.AreSameSystemDates([Date], PVWE.[LocationInDate]) = 1)

-- 		-- Deletes closed by change of day whose elapsed time is less than min configured in points of interest
-- 		DELETE	PV
-- 		FROM	[dbo].[PointOfInterestVisited] PV
-- 				INNER JOIN @Points P ON P.[Id] = PV.[IdPointOfInterest] AND DATEDIFF(MI, PV.[LocationInDate], PV.[LocationOutDate]) < P.[MinElapsedTimeForVisit]
-- 	END
-- END
