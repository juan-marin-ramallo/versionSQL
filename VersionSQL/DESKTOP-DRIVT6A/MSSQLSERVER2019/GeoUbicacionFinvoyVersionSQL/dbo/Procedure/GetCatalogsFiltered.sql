/****** Object:  Procedure [dbo].[GetCatalogsFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCatalogsFiltered] 
	 @CatalogIds [sys].[VARCHAR](MAX) = NULL  
	,@ProductIds [sys].[VARCHAR](MAX) = NULL
	,@ProductCategoriesId [sys].[varchar](max) = NULL 
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
AS 
BEGIN

    SET NOCOUNT ON;

    SELECT  C.[Id], C.[Name], 
			P.[Id] AS ProductId, P.[Name] AS ProductName, P.[BarCode] AS ProductBarCode, P.[Identifier] AS ProductIdentifier, 
			P.[Deleted] AS ProductDeleted
	FROM	[dbo].[Catalog] C
			LEFT JOIN [dbo].[CatalogProduct] CP WITH(NOLOCK) ON CP.[IdCatalog] = C.[Id]
			LEFT JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = CP.[IdProduct]
			LEFT JOIN [dbo].[ProductCategoryList] PCL WITH(NOLOCK) ON PCL.[IdProduct] = P.[Id]
			LEFT OUTER JOIN	[dbo].[ProductBrand] B WITH (NOLOCK) ON B.[Id] = P.IdProductBrand
			LEFT OUTER JOIN	[dbo].[Company] COM WITH (NOLOCK) ON COM.[Id] = B.IdCompany  
	WHERE C.[Deleted] = 0  AND --(P.[Id] IS NULL OR P.Deleted = 0) AND  
			(@CatalogIds IS NULL OR dbo.CheckValueInList (C.[Id], @CatalogIds)=1)  AND
			(@ProductIds IS NULL OR dbo.CheckValueInList(CP.[IdProduct], @ProductIds)=1)  AND
			(@ProductCategoriesId IS NULL OR dbo.CheckValueInList(PCL.[IdProductCategory], @ProductCategoriesId) = 1)	  
			AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(B.[Id] IS NULL, 0, B.[Id]), @IdProductBrand) = 1)
			AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(COM.[Id] IS NULL, 0, COM.[Id]), @IdCompany) = 1)
	GROUP BY C.[Id], C.[Name], P.[Id], P.[Name], P.[BarCode], P.[Identifier], P.[Deleted]
	ORDER BY C.[Name] ASC
END
