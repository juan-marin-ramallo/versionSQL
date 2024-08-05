/****** Object:  Procedure [dbo].[GetPointsOfInterestByIdentifier]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointsOfInterestByIdentifier] 
 	@Identifier [sys].[varchar](100)
AS
BEGIN
	
	SELECT	P.[Id] AS PointOfInterestId, P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier, 
			P.[Address] AS PointOfInterestAddress, 
			P.[Latitude] AS PointOfInterestLatitude, P.[Longitude] AS PointOfInterestLongitude, 
			P.[Radius] AS PointOfInterestRadius
		
	FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)		
						
	WHERE	P.[Deleted] = 0 AND P.[Identifier] = @Identifier 
		
	GROUP BY P.[Id], P.[Name], P.[Identifier], P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[NFCTagId]
END
