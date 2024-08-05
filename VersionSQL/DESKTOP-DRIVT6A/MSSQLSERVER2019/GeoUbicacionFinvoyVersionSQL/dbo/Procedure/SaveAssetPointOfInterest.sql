/****** Object:  Procedure [dbo].[SaveAssetPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveAssetPointOfInterest](
	@IdPointsOfInterest [sys].[VARCHAR](max) = NULL
	,@IdAssets [sys].[VARCHAR](max) = NULL
)
AS 
BEGIN

	INSERT INTO [dbo].[AssetPointOfInterest]  ([IdPointOfInterest], [IdAsset])
	SELECT	POI.[Id], A.[Id]
	FROM	[dbo].[PointOfInterest] AS POI, [dbo].[Asset] AS A
	WHERE	[dbo].[CheckValueInList](POI.[Id], @IdPointsOfInterest) > 0
			AND [dbo].[CheckValueInList](A.[Id], @IdAssets) > 0
			AND NOT EXISTS (SELECT 1 FROM [dbo].[AssetPointOfInterest] AS APOI WHERE APOI.[IdPointOfInterest] = POI.[Id] AND APOI.[IdAsset] = A.[Id] AND APOI.[Deleted] = 0)

END
