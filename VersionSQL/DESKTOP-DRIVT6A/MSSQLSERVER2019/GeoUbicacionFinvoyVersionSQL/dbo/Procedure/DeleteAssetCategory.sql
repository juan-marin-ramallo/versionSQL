/****** Object:  Procedure [dbo].[DeleteAssetCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: <Create Date,,>
-- Description:	Elimina una categorìa de activos
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAssetCategory]
	@Id int
AS
BEGIN
	
	UPDATE [dbo].[AssetCategory]
	SET [IdCategoryFather] = NULL
	WHERE [IdCategoryFather] = @Id

	UPDATE [dbo].[AssetCategory]
	SET [Deleted] = 1
	WHERE [Id] = @Id

	UPDATE [dbo].[Asset]
	SET [IdCategory] = NULL
	WHERE [IdCategory] = @Id

	UPDATE [dbo].[Asset]
	SET [IdSubCategory] = NULL
	WHERE [IdSubCategory] = @Id

END
