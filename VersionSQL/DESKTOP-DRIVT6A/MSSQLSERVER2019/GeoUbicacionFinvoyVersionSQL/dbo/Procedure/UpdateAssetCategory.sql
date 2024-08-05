/****** Object:  Procedure [dbo].[UpdateAssetCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 12/03/21
-- Description:	SP para actualizar una CATEGORIA DE ACTIVOS
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAssetCategory]
	@Id [sys].[int],
	@Identifier [sys].[VARCHAR](50) = NULL,
	@Name [sys].[VARCHAR](50) = NULL, 
	@IdCategoryFather [sys].[int] = NULL,
	@IsSubCategory [sys].[bit] = NULL, 
	@ResultCode [sys].[SMALLINT] OUTPUT
AS
BEGIN
	IF @Identifier IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.[AssetCategory] WITH (NOLOCK) WHERE ([Name] = @Name OR [Identifier] = @Identifier) AND [Deleted] = 0 AND Id <> @Id)
	BEGIN
		SET @ResultCode = -2
    END
	ELSE
	BEGIN
		UPDATE [dbo].[AssetCategory]
		SET  [Name] = @Name
			,[Identifier] = @Identifier
			,[IdCategoryFather] = @IdCategoryFather
			,[IsSubCategory] = @IsSubCategory

		WHERE [Id] = @Id

		SET @ResultCode = 0
    END
END
