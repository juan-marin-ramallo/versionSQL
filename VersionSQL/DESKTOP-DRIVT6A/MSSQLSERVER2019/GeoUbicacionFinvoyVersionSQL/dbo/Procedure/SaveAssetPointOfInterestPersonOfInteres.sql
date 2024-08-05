/****** Object:  Procedure [dbo].[SaveAssetPointOfInterestPersonOfInteres]    Committed by VersionSQL https://www.versionsql.com ******/

--exec [SaveAssetPointOfInterestPersonOfInteres] '4339','1112','15674'
CREATE PROCEDURE [dbo].[SaveAssetPointOfInterestPersonOfInteres](
	@personOfInterestId [sys].[VARCHAR](max) = NULL
	,@assetId [sys].[VARCHAR](max) = NULL
	,@pointOfInterestId [sys].[VARCHAR](max) = NULL
	
)
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @id_asset int = @assetId
	set @pointOfInterestId = ',' + @pointOfInterestId + ','
	set @assetId = ',' + @assetId+ ','


	INSERT INTO [dbo].[AssetPointOfInterest]  ([IdPointOfInterest], [IdAsset])
	SELECT	POI.[Id], A.[Id]
	FROM	[dbo].[PointOfInterest] AS POI, [dbo].[Asset] AS A
	WHERE	[dbo].[CheckValueInList](POI.[Id], @pointOfInterestId) > 0
			AND [dbo].[CheckValueInList](A.[Id], @assetId) > 0
			AND NOT EXISTS (SELECT 1 FROM [dbo].[AssetPointOfInterest] AS APOI WHERE APOI.[IdPointOfInterest] = POI.[Id] AND APOI.[IdAsset] = A.[Id] AND APOI.Deleted = 0)

	update dbo.Asset set [IdPersonOfInterest] = @personOfInterestId
	where [Id] = @id_asset	
	
END
