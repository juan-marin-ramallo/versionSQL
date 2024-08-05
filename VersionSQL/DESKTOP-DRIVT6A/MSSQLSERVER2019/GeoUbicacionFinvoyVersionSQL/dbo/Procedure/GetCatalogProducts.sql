/****** Object:  Procedure [dbo].[GetCatalogProducts]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCatalogProducts]
	 @IdCatalog [int]
	,@ProductIds VARCHAR(MAX) = NULL
	,@ProductCategoriesId [sys].[varchar](max) = NULL 
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
AS
BEGIN

	SELECT P.[Id], P.[Name], P.[BarCode], P.[Identifier]
		  ,C.[Id] AS IdCatalog, C.[Name] AS CatalogName
	FROM Product P
		JOIN CatalogProduct CP ON CP.[IdProduct] = P.[Id]
		JOIN [Catalog] C ON C.[Id] = CP.IdCatalog
		LEFT JOIN [dbo].[ProductCategoryList] PCL WITH(NOLOCK) ON PCL.[IdProduct] = P.[Id]   
		LEFT OUTER JOIN	[dbo].[ProductBrand] B WITH (NOLOCK) ON B.[Id] = P.IdProductBrand
		LEFT OUTER JOIN	[dbo].[Company] CM WITH (NOLOCK) ON CM.[Id] = B.IdCompany
	WHERE CP.[IdCatalog] = @IdCatalog AND P.[Deleted] = 0 AND
		  (@ProductIds IS NULL OR dbo.CheckValueInList(CP.[IdProduct], @ProductIds)=1)  AND
		  (@ProductCategoriesId IS NULL OR dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1)
		  AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(B.[Id] IS NULL, 0, B.[Id]), @IdProductBrand) = 1)
		AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(CM.[Id] IS NULL, 0, CM.[Id]), @IdCompany) = 1)
	GROUP BY P.[Id], P.[Name], P.[BarCode], P.[Identifier], C.[Id], C.[Name]
	ORDER BY P.[Name] ASC

END
