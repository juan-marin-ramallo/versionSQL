/****** Object:  Procedure [dbo].[GetProductsForHash]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetProductsForHash]
AS
BEGIN
  DECLARE @OrderProductCategoryByName AS [sys].[bit]
  	
  SET NOCOUNT ON;

  SET @OrderProductCategoryByName = (SELECT [Value] FROM dbo.[Configuration] WHERE IdConfigurationGroup = 2 and [Name] = 'OrderProductCategory')

  SELECT
    P.[Id]
   ,P.[Name]
   ,P.[Identifier]
   ,P.[BarCode]
   ,P.[Indispensable]
   ,PC.[Id] AS ProductCategoryId
   ,PCL.[Id]
   ,PC.[Name] AS ProductCategoryName
   ,CASE @OrderProductCategoryByName WHEN 1 THEN -1 ELSE PC.[Order] END AS ProductCategoryOrder
   ,b.[Id] AS [ProductBrandId]
   ,b.[Name] AS [ProductBrandName]
   ,b.[Identifier] AS [ProductBrandIdentifier],P.[MinSalesQuantity],P.[MinUnitsPackage], P.[MaxSalesQuantity], P.[InStock],
   P.[Column_1], P.[Column_2],P.[Column_3],P.[Column_4],P.[Column_5],P.[Column_6],P.[Column_7],P.[Column_8],P.[Column_9],
			P.[Column_10], P.[Column_11],P.[Column_12],P.[Column_13],P.[Column_14],P.[Column_15],P.[Column_16],P.[Column_17],
			P.[Column_18], P.[Column_19],P.[Column_20],P.[Column_21],P.[Column_22],P.[Column_23],P.[Column_24],
			P.[Column_25]

  FROM [dbo].[Product] P WITH (NOLOCK)
  LEFT JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK)
    ON PCL.[IdProduct] = P.[Id]
  LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK)
    ON PCL.[IdProductCategory] = PC.[Id]
  LEFT OUTER JOIN dbo.ProductBrand b WITH (NOLOCK)
    ON p.IdProductBrand = b.Id
      AND b.Deleted = 0
  LEFT OUTER JOIN [dbo].[Company] CM WITH (NOLOCK)
    ON CM.[Id] = B.IdCompany
  WHERE P.[Deleted] = 0
  GROUP BY P.[Id]
          ,P.[Name]
          ,P.[Identifier]
          ,P.[BarCode]
		  ,P.[Indispensable]
          ,PC.[Id]
          ,PCL.[Id]
          ,PC.[Name]
		  ,CASE @OrderProductCategoryByName WHEN 1 THEN -1 ELSE PC.[Order] END
          ,b.[Id]
          ,b.[Name]
          ,b.[Identifier],P.[MinSalesQuantity],P.[MinUnitsPackage], P.[MaxSalesQuantity], P.[InStock],
		  P.[Column_1], P.[Column_2],P.[Column_3],P.[Column_4],P.[Column_5],P.[Column_6],P.[Column_7],P.[Column_8],P.[Column_9],
			P.[Column_10], P.[Column_11],P.[Column_12],P.[Column_13],P.[Column_14],P.[Column_15],P.[Column_16],P.[Column_17],
			P.[Column_18], P.[Column_19],P.[Column_20],P.[Column_21],P.[Column_22],P.[Column_23],P.[Column_24],
			P.[Column_25]
  ORDER BY P.[Id], PCL.[Id]
END
