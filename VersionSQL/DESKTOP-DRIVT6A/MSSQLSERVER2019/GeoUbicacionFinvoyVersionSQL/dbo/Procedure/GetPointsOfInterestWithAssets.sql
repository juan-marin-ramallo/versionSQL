/****** Object:  Procedure [dbo].[GetPointsOfInterestWithAssets]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointsOfInterestWithAssets] 
(
	 @IdPointsOfInterest [sys].[varchar](max) = NULL
	,@AssetIds [sys].[varchar](max) = NULL
	,@AssetTypeIds [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	SELECT		P.[Id], P.[Name], P.[Address], P.[Identifier]
	FROM		[dbo].[AssetPointOfInterest] ARP WITH (NOLOCK)
				INNER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = ARP.[IdPointOfInterest]
				INNER JOIN [dbo].[Asset] A WITH (NOLOCK) ON ARP.[IdAsset] = A.[Id]
				LEFT OUTER JOIN [dbo].[PointOfInterestZone] PZ WITH (NOLOCK) ON PZ.[IdPointOfInterest] = P.[Id]
	WHERE		ARP.[Deleted] = 0 AND P.[Deleted] = 0 AND A.[Deleted] = 0 AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckZoneInUserZones(PZ.[IdZone], @IdUser) = 1)) AND
				((@AssetIds IS NULL) OR dbo.CheckValueInList (A.[Id], @AssetIds) = 1) AND
				((@AssetTypeIds IS NULL) OR dbo.CheckValueInList (A.[IdAssetType], @AssetTypeIds) = 1)
	GROUP BY	P.[Id], P.[Name], P.[Address], P.[Identifier]
	ORDER BY	P.[Name]
END
