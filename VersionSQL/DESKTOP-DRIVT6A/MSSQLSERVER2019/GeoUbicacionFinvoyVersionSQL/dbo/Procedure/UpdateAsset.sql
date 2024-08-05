/****** Object:  Procedure [dbo].[UpdateAsset]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[UpdateAsset]
     @Result [sys].[int] OUTPUT
	,@Id [sys].[int]
	,@Identifier [sys].[varchar](50) = NULL
	,@Name [sys].[VARCHAR](50) = NULL
	,@BarCode [sys].[VARCHAR](100) = NULL
	,@ChangeImage [sys].[int]
	,@AssetImageArray [sys].[VARBINARY](MAX) = NULL
	,@IdAssetType [sys].[int] = NULL
	,@IdCompany [sys].[int] = NULL,
	@IdCategory [sys].[int] = NULL,
	@IdSubCategory [sys].[int] = NULL
	
AS 
BEGIN
    SET NOCOUNT ON;
	
	DECLARE @Exist AS [sys].[INT]
    SELECT	@Exist = COUNT(1)
    FROM	dbo.Asset
    WHERE	[Identifier] = @Identifier And [Deleted] = 0 And [Id] <> @Id

	IF @Exist = 0
		BEGIN
		IF @ChangeImage = 1
			BEGIN
				UPDATE	dbo.Asset
				SET		[Name] = @Name, BarCode = @BarCode, Identifier = @Identifier, IdAssetType = @IdAssetType, 
				IdCompany = @IdCompany, IdCategory = @IdCategory, IdSubCategory = @IdSubCategory
				WHERE	[Id] = @Id;
				SELECT @result = @Id
			END
		ELSE
			BEGIN
				UPDATE	dbo.Asset
				SET		[Name] = @Name, BarCode = @BarCode, Identifier = @Identifier, 
						ImageArray = @AssetImageArray, IdAssetType = @IdAssetType, IdCompany = @IdCompany,
						IdCategory = @IdCategory, IdSubCategory = @IdSubCategory
				WHERE	[Id] = @Id;
				SELECT	@result = @Id
			END
		END
	ELSE 
		SELECT @result = -1
END
