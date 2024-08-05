/****** Object:  Procedure [dbo].[GetProductsByPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetProductsByPointOfInterest] (
	 
	 @IdPointOfInterest [sys].[INT]
	,@IdProduct [sys].[varchar](max) = NULL
)
AS
BEGIN
	--DECLARE		@DefaultMinStockLimit [sys].[int] = (SELECT Convert([sys].[int], Value) FROM [dbo].[Configuration] WHERE Id = 20)
	IF EXISTS (SELECT 1 FROM [dbo].[ProductPointOfInterest] WHERE [IdPointOfInterest] = @IdPointOfInterest)
	BEGIN
		SELECT		PR.[Id] AS ProductId, PR.[Name] AS ProductName, 
					PR.[Identifier] AS ProductIdentifier, PR.[BarCode] AS ProductBarCode, PR.[IdProductBrand] AS BrandId,
 					PC.[Id] AS CategoryId, PC.[Name] AS CategoryName, PRP.[TheoricalStock], PRP.[TheoricalPrice]

		FROM		[dbo].[ProductPointOfInterest] PRP WITH (NOLOCK)
					INNER JOIN [dbo].[Product] PR WITH (NOLOCK) ON PRP.[IdProduct] = PR.[Id]
					LEFT JOIN [dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = PR.[Id] AND 
								PCL.[IdProductCategory] = (SELECT  TOP 1  [IdProductCategory]
									FROM    [dbo].[ProductCategoryList]
									WHERE   [IdProduct] = PR.[Id])
					LEFT JOIN [dbo].[ProductCategory] PC ON PC.[Id] = PCL.[IdProductCategory]
	
		WHERE		PR.[Deleted] = 0 AND PRP.[IdPointOfInterest] = @IdPointOfInterest AND
					((@IdProduct IS NULL) OR (dbo.CheckValueInList(PR.[Id], @IdProduct) = 1)) 	
	
		GROUP BY	PR.[Id], PR.[Name], PR.[Identifier], PR.[BarCode], PR.[IdProductBrand], PRP.[TheoricalStock], PRP.[TheoricalPrice], 
					PC.[Id], PC.[Name]
	
		ORDER BY	PR.[Name]		
	END
	ELSE
	BEGIN
		SELECT		PR.[Id] AS ProductId, PR.[Name] AS ProductName, 
					PR.[Identifier] AS ProductIdentifier, PR.[BarCode] AS ProductBarCode, PR.[IdProductBrand] AS BrandId, PC.[Id] AS CategoryId, 
					PC.[Name] AS CategoryName,
					0 AS TheoricalStock, 0 AS TheoricalPrice

		FROM		[dbo].[Product] PR WITH (NOLOCK)
					LEFT JOIN	[dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = PR.[Id] AND 
								PCL.[IdProductCategory] = (	SELECT TOP 1 [IdProductCategory]
															FROM    [dbo].[ProductCategoryList]
															WHERE   [IdProduct] = PR.[Id])
					LEFT JOIN [dbo].[ProductCategory] PC ON PC.[Id] = PCL.[IdProductCategory]
	
		WHERE		PR.[Deleted] = 0 AND
					((@IdProduct IS NULL) OR (dbo.CheckValueInList(PR.[Id], @IdProduct) = 1)) 	
	
		GROUP BY	PR.[Id], PR.[Name], PR.[Identifier], PR.[BarCode], Pr.[IdProductBrand], PC.[Id], PC.[Name]
	
		ORDER BY	PR.[Name]		
	END
END
