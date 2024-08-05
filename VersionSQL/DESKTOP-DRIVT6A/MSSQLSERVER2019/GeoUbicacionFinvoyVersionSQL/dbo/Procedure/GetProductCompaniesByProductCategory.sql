/****** Object:  Procedure [dbo].[GetProductCompaniesByProductCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 02/07/2021
-- Description:	SP para obtener todas las
--				compañías, marcas y submarcas
--				de productos asociadas a la
--				categoría de producto dada por
--				parámetros
-- =============================================
CREATE     PROCEDURE [dbo].[GetProductCompaniesByProductCategory]
	@IdProductCategory [sys].[int] = NULL
AS
BEGIN
	SELECT		C.[Id], C.[Identifier], C.[Name], C.[IsMain], C.[Deleted],
				PB.[Id] AS ProductBrandId, PB.[Identifier] AS ProductBrandIdentifier, PB.[Name] AS ProductBrandName, PB.[Deleted] AS ProductBrandDeleted,
				PSB.[Id] AS ProductSubBrandId, PSB.[Identifier] AS ProductSubBrandIdentifier, PSB.[Name] AS ProductSubBrandName, PSB.[Deleted] AS ProductSubBrandDeleted
	FROM		[dbo].[Company] C
				LEFT OUTER JOIN [dbo].[ProductBrand] PB ON PB.[IdCompany] = C.[Id] AND PB.[IsSubBrand] = 0 --AND PB.[Deleted] = 0
				--INNER JOIN [dbo].[ProductBrandProductCategory] PBPC ON PBPC.[IdProductBrand] = PB.[Id] AND (@IdProductCategory IS NULL OR PBPC.[IdProductCategory] = @IdProductCategory)
				LEFT OUTER JOIN [dbo].[ProductBrand] PSB ON PSB.[IsSubBrand] = 1 AND PSB.[IdFather] = PB.[Id] --AND PSB.[Deleted] = 0
	WHERE		--C.[Deleted] = 0 AND
				(@IdProductCategory IS NULL OR PB.[Id] IN (SELECT PBPC.[IdProductBrand] FROM [dbo].[ProductBrandProductCategory] PBPC WHERE PBPC.[IdProductCategory] = @IdProductCategory))
	ORDER BY	C.[Id], PB.[Id], PSB.[Id]
END
