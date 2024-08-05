/****** Object:  Procedure [dbo].[GetShortageStockTopPoints]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetShortageStockTopPoints]
(
	 @DateFrom [sys].[DATETIME] = '2019-09-01'
	,@DateTo [sys].[datetime] = '2019-11-11'
	,@IdProductst [sys].[varchar](max) = NULL
	,@ProductCategoriesId [sys].[varchar](max) = NULL 
	,@IdShortageType [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS 
BEGIN

    SET NOCOUNT ON;

	SELECT TOP 5 PMG.[IdPointOfInterest] AS PointOfInterestId, PMG.[Name] AS PointOfInterestName, PMG.[Identifier] AS PointOfInterestIdentifier
			, COUNT (1) AS ProductsCount
	FROM (
		SELECT  PM.[IdPointOfInterest], POI.[Name], POI.[Identifier], PMR.IdMissingProductPoi, PMR.IdProduct
		FROM	[dbo].[ProductMissingPointOfInterest] PM WITH(NOLOCK)  
				INNER JOIN	[dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = PM.[IdPointOfInterest]
				INNER JOIN [dbo].[ProductMissingReport] PMR WITH(NOLOCK) ON PMR.IdMissingProductPoi = PM.Id
				INNER JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PMR.[IdProduct]
				LEFT JOIN [dbo].[ProductCategoryList] PCL WITH(NOLOCK) ON PCL.[IdProduct] = P.[Id]
		WHERE	PM.[Deleted] = 0 AND PM.[Date] >= DATEADD(MINUTE, -1, @DateFrom) AND PM.[Date] <= DATEADD(MINUTE, 1, @DateTo) AND PM.[Deleted] = 0
				AND ((@IdProductst IS NULL) OR dbo.CheckValueInList (P.[Id], @IdProductst) = 1) 
				AND ((@ProductCategoriesId IS NULL) OR (dbo.CheckValueInList (PCL.[IdProductCategory], @ProductCategoriesId) = 1)) 
				AND ((@IdShortageType IS NULL) OR (dbo.CheckValueInList(PM.[IdProductMissingType], @IdShortageType) = 1))
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInProductCompanies(P.[IdProductBrand], @IdUser) = 1)) 
		GROUP BY PM.[IdPointOfInterest], POI.[Name], POI.[Identifier], PMR.IdMissingProductPoi, PMR.IdProduct
		) PMG
	GROUP BY PMG.[IdPointOfInterest], PMG.[Name], PMG.[Identifier]
	ORDER BY COUNT (1) DESC
		  
END
