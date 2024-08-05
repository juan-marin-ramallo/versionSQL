/****** Object:  Procedure [dbo].[SaveAsset]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveAsset]
    @Id [sys].[int] OUTPUT,
	@Identifier [sys].[VARCHAR](50) = NULL,
	@Name [sys].[VARCHAR](50) = NULL, 
    @BarCode [sys].[VARCHAR](100) = NULL, 
	@ImageArray [sys].[VARBINARY](MAX) = NULL,
	@IdAssetType [sys].[int] = NULL,
	@IdPersonOfInterest [sys].[int] = NULL,
	@Pending [sys].[bit] = 0,
	@IdCompany [sys].[int] = NULL,
	@IdCategory [sys].[int] = NULL,
	@IdSubCategory [sys].[int] = NULL
	
AS 
BEGIN
    SET NOCOUNT ON;

	DECLARE @Exist AS [sys].[int]
	
    SELECT	@Exist = COUNT(1)
    FROM	dbo.[Asset]
    WHERE	([Identifier] = @Identifier) AND [Deleted] = 0
	
	IF @Exist = 0
	BEGIN
		IF @Pending = 1 --Comes from mobile
		BEGIN
			SELECT	@Pending = CASE [Value] WHEN '1' THEN 0 ELSE 1 END
			FROM	[dbo].[ConfigurationTranslated]
			WHERE	[Id] = 4058 --BypassAssetPendingStatus
		END

		INSERT INTO	dbo.Asset (Name, Identifier, BarCode, ImageArray, Deleted, IdAssetType, IdPersonOfInterest, Pending, IdCompany, [IdCategory], [IdSubCategory])
		VALUES		(@Name, ISNULL(@Identifier, 'GU'), ISNULL(@BarCode, 'GU'), @ImageArray, 0, @IdAssetType, @IdPersonOfInterest, @Pending,@IdCompany,@IdCategory,@IdSubCategory)
		SELECT @Id = SCOPE_IDENTITY()


		DECLARE @RandomId [sys].[varchar](100)
		IF @BarCode IS NULL OR @BarCode = '' OR @Identifier IS NULL OR @Identifier = ''
		BEGIN
			SET @RandomId = CONCAT('GU-', @Id)

			UPDATE  [dbo].[Asset]
			SET		[BarCode] = CASE WHEN ISNULL(@BarCode, '') = '' THEN @RandomId ELSE [BarCode] END
				   ,[Identifier] = CASE WHEN ISNULL(@Identifier, '') = '' THEN @RandomId ELSE [Identifier] END
			WHERE	[Id] = @Id
		END
	END
	ELSE
		SET @Id = -1
END
