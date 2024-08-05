/****** Object:  Procedure [dbo].[GetProductsFilteredForTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetProductsFilteredForTemplate]
	@ProductsId VARCHAR(MAX) = NULL,
	@ProductCategoryId VARCHAR(MAX) = NULL
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdUser int = NULL
AS
BEGIN
SET NOCOUNT ON;

	SELECT P.[Id], P.[Name], P.[Identifier], P.[BarCode], P.[Indispensable], P.[BoxUnits], P.[BoxBarCode],
		PC.[Id] AS ProductCategoryId, PCL.[Id], PC.[Name] AS ProductCategoryName,
		b.[Id] AS [ProductBrandId], b.[Name] AS [ProductBrandName], b.[Identifier] AS [ProductBrandIdentifier],
		P.[MinSalesQuantity],P.[MinUnitsPackage], P.[MaxSalesQuantity], P.[InStock],
		P.[Column_1], P.[Column_2],P.[Column_3],P.[Column_4],P.[Column_5],P.[Column_6],P.[Column_7],P.[Column_8],P.[Column_9],
		P.[Column_10], P.[Column_11],P.[Column_12],P.[Column_13],P.[Column_14],P.[Column_15],P.[Column_16],P.[Column_17],
		P.[Column_18], P.[Column_19],P.[Column_20],P.[Column_21],P.[Column_22],P.[Column_23],P.[Column_24],
		P.[Column_25], P.[TheoricalPrice]

	FROM[dbo].[Product] P WITH (NOLOCK)
	LEFT JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PCL.[IdProduct] = P.[Id]
	LEFT JOIN [dbo].[ProductCategory] PC WITH (NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]
	LEFT OUTER JOIN dbo.ProductBrand b WITH (NOLOCK) ON p.IdProductBrand = b.Id and b.Deleted = 0
	LEFT OUTER JOIN [dbo].[Company] CM WITH (NOLOCK) ON CM.[Id] = B.IdCompany

	WHERE((@ProductsId IS NULL) OR dbo.CheckValueInList(P.[Id], @ProductsId)=1)
	AND ((@ProductCategoryId IS NULL) OR EXISTS
	(
		SELECT TOP(1) 1 FROM [dbo].[ProductCategoryList] WITH (NOLOCK)
		WHERE [IdProduct] = P.[Id] AND dbo.CheckVarcharInList ([IdProductCategory], @ProductCategoryId)=1
	))
	AND P.[Deleted] = 0
	AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(B.[Id] IS NULL, 0, B.[Id]), @IdProductBrand) = 1)
	AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(CM.[Id] IS NULL, 0, CM.[Id]), @IdCompany) = 1)
	AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1))

	GROUP BY P.[Id], P.[Name], P.[Identifier], P.[BarCode], P.[Indispensable], P.[BoxUnits], P.[BoxBarCode],
		PC.[Id] , PCL.[Id], PC.[Name],
		b.[Id] , b.[Name], b.[Identifier],P.[MinSalesQuantity],P.[MinUnitsPackage], P.[MaxSalesQuantity], P.[InStock],
		P.[Column_1], P.[Column_2],P.[Column_3],P.[Column_4],P.[Column_5],P.[Column_6],P.[Column_7],P.[Column_8],P.[Column_9],
		P.[Column_10], P.[Column_11],P.[Column_12],P.[Column_13],P.[Column_14],P.[Column_15],P.[Column_16],P.[Column_17],
		P.[Column_18], P.[Column_19],P.[Column_20],P.[Column_21],P.[Column_22],P.[Column_23],P.[Column_24],
		P.[Column_25], P.[TheoricalPrice]

	ORDER BY P.[Id], PCL.[Id]

	SET NOCOUNT OFF;
END
