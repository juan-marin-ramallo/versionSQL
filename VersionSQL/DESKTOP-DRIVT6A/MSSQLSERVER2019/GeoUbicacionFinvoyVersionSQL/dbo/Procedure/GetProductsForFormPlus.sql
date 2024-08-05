/****** Object:  Procedure [dbo].[GetProductsForFormPlus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Franco Barboza
-- Create date: 26/06/2023
-- Description:	Devuelve los productos de un
--				formulario dado
-- =============================================
CREATE PROCEDURE [dbo].[GetProductsForFormPlus]
	@IdForm [sys].[int]
AS
BEGIN
	SELECT DISTINCT 
		IdProduct = Product.Id, 
		ProductIdentificer = Product.Identifier,
		ProductName = Product.[Name]
	FROM [dbo].[FormPlus] FormPlus
				INNER JOIN dbo.Form F
					ON FormPlus.Idform = f.id
				INNER JOIN [dbo].[FormPlusProduct] FPProduct 
					ON FormPlus.Id = FPProduct.IdFormPlus
				INNER JOIN [dbo].[Product] Product 
					ON FPProduct.IdProduct = Product.Id
				LEFT JOIN [dbo].[ProductCategoryList] ProductCategory
					ON Product.Id = ProductCategory.IdProduct
	WHERE formplus.IdForm = @IdForm
	ORDER BY Product.Id ASC
END
