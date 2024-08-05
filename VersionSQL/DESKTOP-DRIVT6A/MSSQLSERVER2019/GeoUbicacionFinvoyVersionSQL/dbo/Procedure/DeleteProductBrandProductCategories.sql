/****** Object:  Procedure [dbo].[DeleteProductBrandProductCategories]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 30/06/2021
-- Description:	SP para eliminar asociación entre
--				categorías de productos y marcas
--				de productos
-- =============================================
CREATE PROCEDURE [dbo].[DeleteProductBrandProductCategories]
(
	@IdProductBrand [sys].[int]
)
AS
BEGIN
	DELETE FROM [dbo].[ProductBrandProductCategory]
	WHERE [IdProductBrand] = @IdProductBrand
END
