/****** Object:  Procedure [dbo].[GetShortageProductsByPointId]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetShortageProductsByPointId]
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
    ,@IdPointOfInterest [sys].[int]
	,@IdProduct [sys].[varchar](max) = NULL
	,@IdPersonOfInterest [sys].[varchar](max) = NULL
	,@ProductBarCodes [sys].[varchar](max) = NULL
	,@ProductCategoriesId [sys].[varchar](max) = NULL 
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdShortageType [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
AS 
BEGIN

    SET NOCOUNT ON;

    SELECT  P.[Id] AS ProductId, P.[Name] AS ProductName, P.[Identifier] AS ProductIdentifier, 
	P.[BarCode] AS ProductBarCode, PMP.[Date], PMP.[Id], PC.[Name] AS CategoryName, PC.[Id] AS CategoryID
	    
	FROM	[dbo].[ProductMissingPointOfInterest] PMP 
			INNER JOIN [dbo].[ProductMissingReport] PMR ON PMR.[IdMissingProductPoi] = PMP.[Id]
			INNER JOIN [dbo].[Product] P ON P.[Id] = PMR.[IdProduct]
			LEFT JOIN [dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = P.[Id]
			LEFT JOIN [dbo].[ProductCategory] PC ON PCL.[IdProductCategory] = PC.[Id]
			LEFT OUTER JOIN	[dbo].[ProductBrand] PB WITH (NOLOCK) ON PB.[Id] = P.IdProductBrand
			LEFT OUTER JOIN	[dbo].[Company] CM WITH (NOLOCK) ON CM.[Id] = PB.IdCompany
    
	WHERE	--P.[Deleted] = 0 AND 
			PMP.[IdPointOfInterest] = @IdPointOfInterest AND PMP.[Deleted] = 0 AND
			PMP.[Date] BETWEEN @DateFrom AND @DateTo AND
			((@IdProduct IS NULL) OR dbo.CheckVarcharInList (P.[Id], @IdProduct) = 1)  AND
			((@IdPersonOfInterest IS NULL) OR dbo.CheckVarcharInList (PMP.[IdPersonOfInterest], @IdPersonOfInterest) = 1)  AND
			((@ProductBarCodes IS NULL) OR dbo.CheckVarcharInList (P.[Id], @ProductBarCodes)=1) AND
			((@IdShortageType IS NULL) OR (dbo.CheckValueInList(PMP.[IdProductMissingType], @IdShortageType) = 1)) AND
			((@ProductCategoriesId IS NULL) OR (dbo.CheckVarcharInList (PC.[Id], @ProductCategoriesId) = 1))
			AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(PB.[Id] IS NULL, 0, PB.[Id]), @IdProductBrand) = 1)
			AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(CM.[Id] IS NULL, 0, CM.[Id]), @IdCompany) = 1)
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1)) 

	GROUP BY P.[Id], P.[Name], P.[Identifier], P.[BarCode], PMP.[Date], PMP.[Id], PC.[Name], PC.[Id]
	ORDER BY PMP.[Date] DESC
		  
END
