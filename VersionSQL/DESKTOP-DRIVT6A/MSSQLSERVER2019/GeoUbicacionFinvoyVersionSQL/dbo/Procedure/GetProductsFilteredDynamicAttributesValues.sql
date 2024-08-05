/****** Object:  Procedure [dbo].[GetProductsFilteredDynamicAttributesValues]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetProductsFilteredDynamicAttributesValues]
    
	@ProductNames varchar(max) = NULL, 
    @ProductIds varchar(max) = NULL,
	@ProductBarCodes varchar(max) = NULL ,
	@IdUser int = NULL

AS 
BEGIN
    
    SELECT	 P.[Id], P.[Name], P.[Identifier], P.[BarCode], P.[Deleted],P.[Indispensable],
			 b.[Id] AS [ProductBrandId], b.[Name] AS [ProductBrandName], PDA.*

    
	FROM	dbo.[Product] P
			LEFT JOIN [dbo].[ProductDynamicAttributeValue] PDA ON PDA.[IdProduct] = P.[Id]
			LEFT OUTER JOIN dbo.ProductBrand b ON  p.IdProductBrand = b.Id    
    
	WHERE	((@ProductNames IS NULL) OR dbo.CheckVarcharInList (P.[Name], @ProductNames) = 1)  AND
			((@ProductBarCodes IS NULL) OR dbo.CheckVarcharInList (P.[BarCode], @ProductBarCodes) = 1) AND 
			((@ProductIds IS NULL) OR dbo.CheckValueInList (P.[Id], @ProductIds) = 1) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1))

	order by P.[Id]
END
