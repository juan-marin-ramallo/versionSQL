/****** Object:  Procedure [dbo].[GetProductBrandsProductCategories]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 02/07/2021
-- Description:	SP para obtener las categorías de
--				productos asociadas a las marcas
--				de productos dadas por parámetros
-- =============================================
CREATE PROCEDURE [dbo].[GetProductBrandsProductCategories]
(
	@IdProductBrands [sys].[varchar](MAX)
)
AS
BEGIN
	SELECT		PBPC.[IdProductBrand], PC.[Id], PC.[Name]
	FROM		[dbo].[ProductBrandProductCategory] PBPC
				INNER JOIN [dbo].[ProductCategory] PC ON PC.[Id] = PBPC.[IdProductCategory]
	WHERE		[dbo].CheckValueInList(PBPC.[IdProductBrand], @IdProductBrands) > 0
	ORDER BY	PBPC.[IdProductBrand], PC.[Name]
END
