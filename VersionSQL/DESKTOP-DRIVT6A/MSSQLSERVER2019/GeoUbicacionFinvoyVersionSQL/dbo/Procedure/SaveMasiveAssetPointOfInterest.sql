/****** Object:  Procedure [dbo].[SaveMasiveAssetPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveMasiveAssetPointOfInterest](
	@PointOfInterestIdentifier [sys].[varchar](50)
	,@AssetBarCode [sys].[varchar](100) = NULL
	,@Result [sys].[int] OUTPUT
)
AS 
BEGIN
	SET @Result = 0
	DECLARE @PointOfInterestId [sys].[int] = (SELECT p.[Id] FROM [dbo].[PointOfInterest] p WHERE p.[Identifier] = @PointOfInterestIdentifier)
	DECLARE @AssetId [sys].[int] = (SELECT a.[Id] FROM [dbo].[Asset] a WHERE (@AssetBarCode IS NOT NULL AND @AssetBarCode = a.[BarCode]))

	IF(@PointOfInterestId IS NOT NULL AND @AssetId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [dbo].[AssetPointOfInterest] WHERE [IdAsset] = @AssetId AND [IdPointOfInterest] = @PointOfInterestId AND [Deleted] = 0))
	BEGIN
		INSERT INTO [dbo].[AssetPointOfInterest] (IdAsset, IdPointOfInterest)
		VALUES (@AssetId ,@PointOfInterestId )
		SET @Result = 1
	END
END
