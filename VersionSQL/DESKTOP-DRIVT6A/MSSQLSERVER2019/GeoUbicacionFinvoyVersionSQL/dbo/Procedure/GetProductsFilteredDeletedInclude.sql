/****** Object:  Procedure [dbo].[GetProductsFilteredDeletedInclude]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetProductsFilteredDeletedInclude]
    
	@ProductNames varchar(max) = NULL, 
    @ProductIds varchar(max) = NULL,
	@ProductBarCodes varchar(max) = NULL ,
	@ProductCategoryId varchar(max) = NULL,
	@IdUser int = NULL

AS 
BEGIN
    
    SELECT	 P.Id, P.[Name], P.[Identifier], P.[BarCode], P.[Deleted],P.[Indispensable], PC.[Id] AS ProductCategoryId, PC.[Name] AS ProductCategoryName
			,b.[Id] AS [ProductBrandId], b.[Name] AS [ProductBrandName]
    
	FROM	dbo.[Product] P
			LEFT JOIN [dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = P.[Id]
			LEFT JOIN [dbo].[ProductCategory] PC ON PCL.[IdProductCategory] = PC.[Id]
			LEFT OUTER JOIN dbo.ProductBrand b ON  p.IdProductBrand = b.Id    
    
	WHERE	((@ProductNames IS NULL) OR dbo.CheckVarcharInList (P.[Name], @ProductNames) = 1)  AND
			((@ProductBarCodes IS NULL) OR dbo.CheckVarcharInList (P.[BarCode], @ProductBarCodes) = 1) AND 
			((@ProductIds IS NULL) OR dbo.CheckValueInList (P.[Id], @ProductIds) = 1) AND
			((@ProductCategoryId IS NULL) OR dbo.CheckVarcharInList (PCL.[IdProductCategory], @ProductCategoryId)=1)
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1))

	order by [Deleted], [Name], PCL.[Id]
END
