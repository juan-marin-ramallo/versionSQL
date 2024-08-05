/****** Object:  Procedure [dbo].[GetShortageStockTopProducts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetShortageStockTopProducts]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@ProductCategoriesId [sys].[varchar](max) = NULL 
	,@IdShortageType [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS 
BEGIN

    SET NOCOUNT ON;

    SELECT  TOP 5 P.[Id] AS ProductId, P.[Name] AS ProductName, P.[Identifier] AS ProductIdentifier, P.[BarCode] AS ProductBarCode
			, COUNT(DISTINCT PMR.IdMissingProductPoi) AS PointsCount
	FROM	[dbo].[ProductMissingPointOfInterest] PM WITH(NOLOCK)  
			INNER JOIN [dbo].[ProductMissingReport] PMR WITH(NOLOCK) ON PMR.IdMissingProductPoi = PM.Id
			INNER JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PMR.[IdProduct]
			LEFT JOIN [dbo].[ProductCategoryList] PCL WITH(NOLOCK) ON PCL.[IdProduct] = P.[Id]
	WHERE	PM.[Deleted] = 0 AND PM.[Date] >= DATEADD(MINUTE, -1, @DateFrom) AND PM.[Date] <= DATEADD(MINUTE, 1, @DateTo)
			AND ((@IdPointsOfInterest IS NULL) OR dbo.CheckValueInList (PM.[IdPointOfInterest], @IdPointsOfInterest) = 1) 
			AND ((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList (PCL.[IdProductCategory], @ProductCategoriesId) = 1)) 
			AND ((@IdShortageType IS NULL) OR (dbo.CheckValueInList(PM.[IdProductMissingType], @IdShortageType) = 1))
			AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1)) 
	GROUP BY P.[Id], P.[Name], P.[Identifier], P.[BarCode]
	ORDER BY COUNT(DISTINCT PMR.IdMissingProductPoi) DESC
		  
END
