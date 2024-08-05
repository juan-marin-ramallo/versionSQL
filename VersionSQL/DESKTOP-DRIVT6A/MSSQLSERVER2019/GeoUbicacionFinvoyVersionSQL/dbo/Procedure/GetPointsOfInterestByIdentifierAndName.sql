/****** Object:  Procedure [dbo].[GetPointsOfInterestByIdentifierAndName]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointsOfInterestByIdentifierAndName] 
 	@Identifier [sys].[varchar](100) = NULL,
	@Name [sys].[varchar](100) = NULL,
	@IdPersonOfInterest [sys].[int]
AS
BEGIN
	DECLARE @ShowOnlyZonesPoint [sys].[int] 
	CREATE TABLE #TempResultPoints
    ( 
		PointOfInterestId int,
    );	
	
	SET @ShowOnlyZonesPoint = CAST( (SELECT [Value] FROM [dbo].[Configuration] WITH (NOLOCK) WHERE [Id] = 4072) AS [sys].[int] )

	IF @ShowOnlyZonesPoint = 1
	begin
		INSERT INTO #TempResultPoints
		SELECT IdPointOfInterest 
		FROM PointOfInterestZone WITH (NOLOCK) 
		WHERE IdZone in (SELECT	IdZone FROM PersonOfInterestZone WITH (NOLOCK) WHERE IdPersonOfInterest = @IdPersonOfInterest)
	end
	
	
	SELECT	TOP 100 P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
			P.[Address] AS PointOfInterestAddress, 
			P.[Latitude] AS PointOfInterestLatitude, P.[Longitude] AS PointOfInterestLongitude, 
			P.[Radius] AS PointOfInterestRadius
		
	FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)		
						
	WHERE	P.[Deleted] = 0 AND (P.[Identifier] LIKE '%' + @Identifier + '%' 
			OR REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(P.[Name], 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') LIKE '%' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Name, 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u') + '%')
			AND ((@ShowOnlyZonesPoint = 0 OR NOT EXISTS(SELECT 1 FROM #TempResultPoints)) 
						OR (P.[Id] IN (SELECT PointOfInterestId FROM #TempResultPoints)))
		
	GROUP BY P.[Id], P.[Name], P.[Identifier], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[NFCTagId]

	drop table #TempResultPoints
END
