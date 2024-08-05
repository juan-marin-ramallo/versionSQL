/****** Object:  Procedure [dbo].[UpdateProductBrand]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 18/03/19
-- Description:	SP para actualizar una marcas
-- =============================================
CREATE PROCEDURE [dbo].[UpdateProductBrand]
	 @Id [sys].[int]
	,@IdCompany [sys].[int]
	,@Name [sys].[VARCHAR](50)
	,@Identifier [sys].[VARCHAR](50) = null
	,@Description [sys].[VARCHAR](512) = null
	,@ImageName [sys].[VARCHAR](256) = null
	,@IsSubBrand [sys].[bit]
	,@IdFather [sys].[INT] = NULL
    ,@ResultCode [sys].[SMALLINT] OUTPUT
AS
BEGIN
	IF @Identifier IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.[ProductBrand] WITH (NOLOCK) WHERE [Identifier] = @Identifier AND Deleted = 0 AND Id <> @Id)
	BEGIN
		SET @ResultCode = -2
    END
	ELSE
	BEGIN
		UPDATE [dbo].[ProductBrand]
		SET  [IdCompany] = @IdCompany
			,[Name] = @Name
			,[Identifier] = @Identifier
			,[Description] = @Description
			,[ImageName] = @ImageName
			,[IsSubBrand] = @IsSubBrand
			,[IdFather] = @IdFather
		WHERE [Id] = @Id

		SET @ResultCode = 0
    END
END
