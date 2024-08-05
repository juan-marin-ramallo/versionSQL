/****** Object:  Procedure [dbo].[GetAllPointsOfInterestInRoute]    Committed by VersionSQL https://www.versionsql.com ******/

--exec GetAllPointsOfInterestInRoute 501,'-24.780047','-65.426951'
CREATE PROCEDURE [dbo].[GetAllPointsOfInterestInRoute]
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
	

	CREATE TABLE #PointsNearLocation
(
  PointOfInterestId int,
  PointOfInterestName varchar(100),
  PointOfInterestIdentifier	varchar(100),
  PointOfInterestAddress varchar(100),
  PointOfInterestLatitude varchar(100),
  PointOfInterestLongitude varchar(100),
  PointOfInterestRadius	varchar(100),
  InPoint varchar(100),
  InRoute varchar(100),
  PointOfInterestNFC varchar(100),
  PointHasImage varchar(100)
)
INSERT #PointsNearLocation exec [GetNearPointsOfInterest] @IdPersonOfInterest,@Latitude,@Longitude

	
	SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
				P.[Address] AS PointOfInterestAddress, 
				P.[Latitude] AS PointOfInterestLatitude, P.[Longitude] AS PointOfInterestLongitude, 
				P.[Radius] AS PointOfInterestRadius, 0 AS InPoint, 0 AS [InRoute], P.[NFCTagId] AS PointOfInterestNFC,
				IIF(P.[Image] IS NULL, IIF(P.[ImageUrl] IS NULL, 0, 1), 1) AS PointHasImage
		
		FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)		
				LEFT OUTER JOIN [RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[IdPointOfInterest] = P.[Id]
				INNER JOIN [dbo].[RouteGroup] RG WITH (NOLOCK) ON RP.[IdRouteGroup] = RG.[Id]
				INNER JOIN  [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id] 
							AND Tzdb.FromUtc(RD.[RouteDate]) >= @SystemToday AND Tzdb.FromUtc(RD.[RouteDate]) < DATEADD(DAY, 1, @SystemToday)
				LEFT JOIN #PointsNearLocation t on t.PointOfInterestId = p.Id
		
		WHERE	P.[Deleted] = 0
				AND (P.[LatLong].STDistance(@PersonOfInterestLatLong) - P.[Radius]) <= @Radius
				AND RD.Id IS not NULL
				AND ((@ShowOnlyZonesPoint = 0 OR NOT EXISTS(SELECT 1 FROM #TempResultPoints)) 
						OR (P.[Id] IN (SELECT 1 FROM #TempResultPoints)))
				and t.PointOfInterestId is null
				
		GROUP BY P.[Id], P.[Name], P.[Identifier], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[NFCTagId], IIF(P.[Image] IS NULL, IIF(P.[ImageUrl] IS NULL, 0, 1), 1)


		drop table #TempResultPoints
		drop table #PointsNearLocation
	/*
	DECLARE @SystemToday [sys].[datetime]
	SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)

	SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
				P.[Address] AS PointOfInterestAddress, 
				P.[Latitude] AS PointOfInterestLatitude, P.[Longitude] AS PointOfInterestLongitude, 
				P.[Radius] AS PointOfInterestRadius, 0 AS InPoint, 0 AS [InRoute], P.[NFCTagId] AS PointOfInterestNFC,
				IIF(P.[Image] IS NULL, IIF(P.[ImageUrl] IS NULL, 0, 1), 1) AS PointHasImage
		
		FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)		
				LEFT OUTER JOIN [RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[IdPointOfInterest] = P.[Id]
				INNER JOIN [dbo].[RouteGroup] RG WITH (NOLOCK) ON RP.[IdRouteGroup] = RG.[Id]
				INNER JOIN  [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id] 
							AND Tzdb.FromUtc(RD.[RouteDate]) >= @SystemToday AND Tzdb.FromUtc(RD.[RouteDate]) < DATEADD(DAY, 1, @SystemToday)



							
		WHERE	RD.[Disabled] = 0
		AND RG.[IdPersonOfInterest] = @IdPersonOfInterest
		AND P.[Deleted] = 0

		GROUP BY P.[Id], P.[Name], P.[Identifier], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[NFCTagId], IIF(P.[Image] IS NULL, IIF(P.[ImageUrl] IS NULL, 0, 1), 1)
		*/
END
