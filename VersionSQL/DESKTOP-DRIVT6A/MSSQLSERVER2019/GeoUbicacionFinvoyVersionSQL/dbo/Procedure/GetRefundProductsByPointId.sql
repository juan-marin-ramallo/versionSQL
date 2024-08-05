/****** Object:  Procedure [dbo].[GetRefundProductsByPointId]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetRefundProductsByPointId]
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
    ,@IdPointOfInterest [sys].[int]
	,@IdProduct [sys].[varchar](max) = NULL
	,@IdPersonOfInterest [sys].[varchar](max) = NULL
	,@ProductBarCodes [sys].[varchar](max) = NULL
	,@ProductCategoriesId [sys].[varchar](max) = NULL 
	,@IdCompany [sys].[varchar](max) = NULL
	,@IdProductBrand [sys].[varchar](max) = NULL
	,@IdUser [sys].INT = NULL
AS 
BEGIN

    SET NOCOUNT ON;

    SELECT  P.[Id] AS ProductId, P.[Name] AS ProductName, P.[Identifier] AS ProductIdentifier, 
	P.[BarCode] AS ProductBarCode, PR.[Date], PR.[Id], PR.[Quantity], PR.[Description]
    
	FROM	[dbo].[ProductRefund] PR 
			INNER JOIN [dbo].[Product] P ON P.[Id] = PR.[IdProduct]
			LEFT JOIN [dbo].[ProductCategoryList] PCL ON PCL.[IdProduct] = P.[Id]
			LEFT JOIN [dbo].[ProductCategory] PC ON PCL.[IdProductCategory] = PC.[Id]
			LEFT OUTER JOIN	[dbo].[ProductBrand] PB WITH (NOLOCK) ON PB.[Id] = P.IdProductBrand
			LEFT OUTER JOIN	[dbo].[Company] CM WITH (NOLOCK) ON CM.[Id] = PB.IdCompany
    
	WHERE	--P.[Deleted] = 0 AND 
			PR.[IdPointOfInterest] = @IdPointOfInterest AND
			PR.[Date] BETWEEN @DateFrom AND @DateTo AND
			((@IdProduct IS NULL) OR dbo.CheckVarcharInList (P.[Id], @IdProduct) = 1)  AND
			((@IdPersonOfInterest IS NULL) OR dbo.CheckVarcharInList (PR.[IdPersonOfInterest], @IdPersonOfInterest) = 1)  AND
			((@ProductBarCodes IS NULL) OR dbo.CheckVarcharInList (P.[Id], @ProductBarCodes)=1) AND
			((@ProductCategoriesId IS NULL) OR (dbo.CheckVarcharInList (PC.[Id], @ProductCategoriesId) = 1))
			AND (@IdProductBrand IS NULL OR dbo.CheckValueInList(IIF(PB.[Id] IS NULL, 0, PB.[Id]), @IdProductBrand) = 1)
			AND (@IdCompany IS NULL OR dbo.CheckValueInList(IIF(CM.[Id] IS NULL, 0, CM.[Id]), @IdCompany) = 1)
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1))

	GROUP BY P.[Id], P.[Name], P.[Identifier], P.[BarCode], PR.[Date], PR.[Id], PR.[Quantity], PR.[Description]
	ORDER BY PR.[Date] DESC
		  
END
