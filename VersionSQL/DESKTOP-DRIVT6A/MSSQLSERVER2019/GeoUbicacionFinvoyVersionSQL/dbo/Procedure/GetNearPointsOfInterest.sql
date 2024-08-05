/****** Object:  Procedure [dbo].[GetNearPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetNearPointsOfInterest] 
 	@IdPersonOfInterest [sys].[int],
	@Latitude [sys].[decimal](25, 20) = NULL,
	@Longitude [sys].[decimal](25, 20) = NULL
AS
BEGIN
	DECLARE @Radius [sys].[int]
	DECLARE @PersonOfInterestLatLong [sys].[geography] 
	DECLARE @IdPersonOfInterestLocal [sys].[int] = @IdPersonOfInterest
	DECLARE @LatitudeLocal [sys].[decimal](25, 20) = @Latitude
	DECLARE @LongitudeLocal [sys].[decimal](25, 20) = @Longitude
	DECLARE @ShowOnlyZonesPoint [sys].[int] 
	CREATE TABLE #TempResultPoints
    ( 
		PointOfInterestId int,
    );

	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

	IF @LatitudeLocal IS NULL AND @LongitudeLocal IS NULL
	BEGIN
		SET @PersonOfInterestLatLong = (SELECT TOP 1 [LatLong] FROM [dbo].[CurrentLocation] WITH (NOLOCK) WHERE [IdPersonOfInterest] = @IdPersonOfInterestLocal ORDER BY [Date] DESC)
	END
	ELSE
	BEGIN
		SET @PersonOfInterestLatLong = GEOGRAPHY::STPointFromText('POINT(' + CAST(@LongitudeLocal AS VARCHAR(25)) + ' ' + CAST(@LatitudeLocal AS VARCHAR(25)) + ')', 4326)
	END

	SET @Radius = CAST( (SELECT [Value] FROM [dbo].[Configuration] WITH (NOLOCK) WHERE [Id] = 12) AS [sys].[int] )
	SET @ShowOnlyZonesPoint = CAST( (SELECT [Value] FROM [dbo].[Configuration] WITH (NOLOCK) WHERE [Id] = 4072) AS [sys].[int] )

	IF @ShowOnlyZonesPoint = 1
	begin
		INSERT INTO #TempResultPoints
		SELECT IdPointOfInterest 
		FROM PointOfInterestZone WITH (NOLOCK) 
		WHERE IdZone in (SELECT	IdZone FROM PersonOfInterestZone WITH (NOLOCK) WHERE IdPersonOfInterest = @IdPersonOfInterest)
	end

	;WITH PersonRoutesDetail([Id], [RouteDate], [RouteDateSystem], [IdRoutePointOfInterest]) AS
	(
		SELECT	RD.[Id], RD.[RouteDate], Tzdb.FromUtc(RD.[RouteDate]) AS RouteDateSystem, RD.[IdRoutePointOfInterest]
		FROM	[dbo].[RouteDetail] RD WITH (NOLOCK)
		WHERE	RD.[Disabled] = 0
	),
	TodayPersonRoutes([IdRouteDetail], [IdPointOfInterest]) AS
	(
		SELECT	RD.[Id], RP.[IdPointOfInterest]
		FROM	[dbo].[RouteGroup] RG WITH (NOLOCK) 
				INNER JOIN [dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[IdRouteGroup] = RG.[Id]
				INNER JOIN PersonRoutesDetail RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id] 
							AND RD.[RouteDateSystem] >= @SystemToday AND RD.[RouteDateSystem] < DATEADD(DAY, 1, @SystemToday)
		WHERE	RG.[IdPersonOfInterest] = @IdPersonOfInterestLocal
	)
	
	SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
				P.[Address] AS PointOfInterestAddress, 
				P.[Latitude] AS PointOfInterestLatitude, P.[Longitude] AS PointOfInterestLongitude, 
				P.[Radius] AS PointOfInterestRadius, 0 AS InPoint, 0 AS [InRoute], P.[NFCTagId] AS PointOfInterestNFC,
				IIF(P.[Image] IS NULL, IIF(P.[ImageUrl] IS NULL, 0, 1), 1) AS PointHasImage
		
		FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)		
				LEFT OUTER JOIN TodayPersonRoutes TPR WITH (NOLOCK) ON TPR.[IdPointOfInterest] = P.[Id]
		
		WHERE	P.[Deleted] = 0
				AND (P.[LatLong].STDistance(@PersonOfInterestLatLong) - P.[Radius]) <= @Radius
				AND TPR.[IdRouteDetail] IS NULL
				AND ((@ShowOnlyZonesPoint = 0 OR NOT EXISTS(SELECT 1 FROM #TempResultPoints)) 
						OR (P.[Id] IN (SELECT PointOfInterestId FROM #TempResultPoints)))
		
		GROUP BY P.[Id], P.[Name], P.[Identifier], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[NFCTagId], IIF(P.[Image] IS NULL, IIF(P.[ImageUrl] IS NULL, 0, 1), 1)


		drop table #TempResultPoints
END

-- OLD)
--BEGIN
--	DECLARE @Radius [sys].[int]
--	DECLARE @PersonOfInterestLatLong [sys].[geography] 
--	DECLARE @IdPersonOfInterestLocal [sys].[int] = @IdPersonOfInterest
--	DECLARE @LatitudeLocal [sys].[decimal](25, 20) = @Latitude
--	DECLARE @LongitudeLocal [sys].[decimal](25, 20) = @Longitude

--	IF @LatitudeLocal IS NULL AND @LongitudeLocal IS NULL
--	BEGIN
--		SET @PersonOfInterestLatLong = (SELECT TOP 1 [LatLong] FROM [dbo].[CurrentLocation] WITH (NOLOCK) WHERE [IdPersonOfInterest] = @IdPersonOfInterestLocal ORDER BY [Date] DESC)
--	END
--	ELSE
--	BEGIN
--		SET @PersonOfInterestLatLong = GEOGRAPHY::STPointFromText('POINT(' + CAST(@LongitudeLocal AS VARCHAR(25)) + ' ' + CAST(@LatitudeLocal AS VARCHAR(25)) + ')', 4326)
--	END

--	SET @Radius = CAST( (SELECT [Value] FROM [dbo].[Configuration] WITH (NOLOCK) WHERE [Id] = 12) AS [sys].[int] )
	
--	SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
--				P.[Address] AS PointOfInterestAddress, 
--				P.[Latitude] AS PointOfInterestLatitude, P.[Longitude] AS PointOfInterestLongitude, 
--				P.[Radius] AS PointOfInterestRadius, 0 AS InPoint, 0 AS [InRoute], P.[NFCTagId] AS PointOfInterestNFC
		
--		FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)		
--				LEFT OUTER JOIN [dbo].[RouteGroup] RG WITH (NOLOCK) ON RG.[IdPersonOfInterest] = @IdPersonOfInterestLocal
--				LEFT OUTER JOIN [dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[IdRouteGroup] = RG.[Id] AND RP.[IdPointOfInterest] = P.[Id] 
--				LEFT OUTER JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id] AND Tzdb.AreSameSystemDates(RD.[RouteDate], GETUTCDATE()) = 1
		
--		WHERE	(P.[LatLong].STDistance(@PersonOfInterestLatLong) - P.[Radius]) <= @Radius
--				AND P.[Deleted] = 0 
--				AND NOT EXISTS 
--				(
--					SELECT 1 
--					FROM	[dbo].[RouteGroup] RG WITH (NOLOCK) 
--							INNER JOIN [dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[IdRouteGroup] = RG.[Id] AND RP.[IdPointOfInterest] = P.[Id] 
--							INNER JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id] AND Tzdb.AreSameSystemDates(RD.[RouteDate], GETUTCDATE()) = 1
--					WHERE	RG.[IdPersonOfInterest] = @IdPersonOfInterestLocal AND RD.[Disabled] = 0
--				)
		
--		GROUP BY P.[Id], P.[Name], P.[Identifier], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[NFCTagId]
--END
