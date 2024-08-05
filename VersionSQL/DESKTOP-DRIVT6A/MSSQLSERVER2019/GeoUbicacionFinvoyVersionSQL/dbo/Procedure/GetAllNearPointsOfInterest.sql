/****** Object:  Procedure [dbo].[GetAllNearPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetAllNearPointsOfInterest] 
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

	IF @LatitudeLocal IS NULL AND @LongitudeLocal IS NULL
	BEGIN
		SET @PersonOfInterestLatLong = (SELECT TOP 1 [LatLong] FROM [dbo].[CurrentLocation] 
		WHERE [IdPersonOfInterest] = @IdPersonOfInterestLocal ORDER BY [Date] DESC)
	END
	ELSE
	BEGIN
		SET @PersonOfInterestLatLong = GEOGRAPHY::STPointFromText('POINT(' + CAST(@LongitudeLocal AS VARCHAR(25)) + ' ' + CAST(@LatitudeLocal AS VARCHAR(25)) + ')', 4326)
	END

	SET @Radius = CAST( (SELECT [Value] FROM [dbo].[ConfigurationTranslated] WHERE [Id] = 2052) AS [sys].[int] )

	SET @ShowOnlyZonesPoint = CAST( (SELECT [Value] FROM [dbo].[Configuration] WITH (NOLOCK) WHERE [Id] = 4072) AS [sys].[int] )

	IF @ShowOnlyZonesPoint = 1
	begin
		INSERT INTO #TempResultPoints
		SELECT IdPointOfInterest 
		FROM PointOfInterestZone WITH (NOLOCK) 
		WHERE IdZone in (SELECT	IdZone FROM PersonOfInterestZone WITH (NOLOCK) WHERE IdPersonOfInterest = @IdPersonOfInterest)
	end

	SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
				P.[Address] AS PointOfInterestAddress, 
				P.[Latitude] AS PointOfInterestLatitude, P.[Longitude] AS PointOfInterestLongitude, 
				P.[Radius] AS PointOfInterestRadius, P.[NFCTagId] AS PointOfInterestNFC,
				IIF(P.[Image] IS NULL, IIF(P.[ImageUrl] IS NULL, 0, 1), 1) AS PointHasImage
		
		FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)		
		
		WHERE	(P.[LatLong].STDistance(@PersonOfInterestLatLong) - P.[Radius]) <= @Radius
				AND P.[Deleted] = 0 
				AND ((@ShowOnlyZonesPoint = 0 OR NOT EXISTS(SELECT 1 FROM #TempResultPoints)) 
						OR (P.[Id] IN (SELECT PointOfInterestId FROM #TempResultPoints)))
		
		GROUP BY P.[Id], P.[Name], P.[Identifier], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[NFCTagId], P.[Image], P.[ImageUrl]
END
