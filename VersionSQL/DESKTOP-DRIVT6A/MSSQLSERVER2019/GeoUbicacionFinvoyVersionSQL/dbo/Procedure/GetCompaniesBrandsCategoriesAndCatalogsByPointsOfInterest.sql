/****** Object:  Procedure [dbo].[GetCompaniesBrandsCategoriesAndCatalogsByPointsOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 10/04/2023
-- Description:	SP para obtener las compañías,
--				marcas, categorías de productos
--				y catálogos asociados a
--				productos en puntos de interés
-- =============================================
CREATE PROCEDURE [dbo].[GetCompaniesBrandsCategoriesAndCatalogsByPointsOfInterest]
(
	 @IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IncludeDeleted [sys].[bit] = 0
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	CREATE TABLE #ProductIds
	(
		 [Id] [sys].[int] NOT NULL
		,[IdProductBrand] [sys].[int] NULL
	)

	IF EXISTS (SELECT	TOP (1) 1
				FROM	[dbo].[PointOfInterest] P WITH (NOLOCK)
						LEFT JOIN [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK) ON PPOI.[IdPointOfInterest] = P.[Id]
				WHERE	P.[Deleted] = 0
						AND PPOI.[Id] IS NULL
						AND (CASE WHEN @IdPointsOfInterest IS NULL THEN 1 ELSE [dbo].[CheckValueInList](P.[Id], @IdPointsOfInterest) END) > 0)
	BEGIN
		INSERT INTO #ProductIds
		SELECT	[Id], [IdProductBrand]
		FROM	[dbo].[Product] WITH (NOLOCK)
		WHERE	[Deleted] = 0
	END

	ELSE
	BEGIN
		INSERT INTO #ProductIds
		SELECT		P.[Id], P.[IdProductBrand]
		FROM		[dbo].[Product] P WITH (NOLOCK)
					INNER JOIN [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK) ON PPOI.[IdProduct] = P.[Id]
		WHERE		P.[Deleted] = 0
					AND (CASE WHEN @IdPointsOfInterest IS NULL THEN 1 ELSE [dbo].[CheckValueInList](PPOI.[IdPointOfInterest], @IdPointsOfInterest) END) > 0
		GROUP BY	P.[Id], P.[IdProductBrand]
	END

	SELECT		C.[Id] AS IdCompany, C.[Name] AS CompanyName, C.[Identifier] AS CompanyIdentifier, C.[Deleted] AS CompanyDeleted,
				PB.[Id] AS IdProductBrand, PB.[Name] AS ProductBrandName, PB.[Identifier] AS ProductBrandIdentifier, PB.[IsSubBrand] AS ProductBrandIsSubBrand, PB.[Deleted] AS ProductBrandDeleted
	FROM		[dbo].[ProductBrand] PB WITH (NOLOCK)
				INNER JOIN [dbo].[Company] C WITH (NOLOCK) ON C.[Id] = PB.[IdCompany]
				LEFT JOIN [dbo].[ProductBrand] SUBPB WITH (NOLOCK) ON SUBPB.[Id] = PB.[IdFather]
				INNER JOIN #ProductIds P ON P.[IdProductBrand] = PB.[Id]
	WHERE		(PB.[Deleted] = 0 OR @IncludeDeleted = 1)
				AND (C.[Deleted] = 0 OR @IncludeDeleted = 1)
				AND ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(C.[Id], @IdUser) = 1))
	GROUP BY	C.[Id], C.[Name], C.[Identifier], C.[Deleted], C.[IsMain],
				PB.[Id], PB.[Name], PB.[Identifier], PB.[IsSubBrand], PB.[Deleted],
				SUBPB.[Id], SUBPB.[Name]
	ORDER BY	C.[IsMain] DESC, C.[Name] ASC, IIF(SUBPB.[Id] IS NULL, PB.[Name], SUBPB.[Name]) ASC, PB.[IsSubBrand] ASC

	SELECT		PC.[Id], PC.[Name], PC.[Deleted]
	FROM		[dbo].[ProductCategory] PC WITH (NOLOCK)
				INNER JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON PCL.[IdProductCategory] = PC.[Id]
				INNER JOIN #ProductIds P ON P.[Id] = PCL.[IdProduct]
	WHERE		PC.[Deleted] = 0 OR @IncludeDeleted = 1
	GROUP BY	PC.[Id], PC.[Name], PC.[Deleted]
	ORDER BY	PC.[Name] ASC

	SELECT		C.[Id], C.[Name], C.[Deleted]
	FROM		[dbo].[Catalog] C WITH (NOLOCK)
				INNER JOIN [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK) ON PPOI.[IdCatalog] = C.[Id]
				LEFT JOIN [dbo].[CatalogPersonOfInterestPermission] CPOIP WITH (NOLOCK) ON CPOIP.[IdCatalog] = C.[Id]
	WHERE		(C.[Deleted] = 0 OR @IncludeDeleted = 1)
				AND (CPOIP.[Id] IS NULL OR CPOIP.[IdPersonOfInterestPermission] = 35) -- All actions or has Forms permission
				AND (CASE WHEN @IdPointsOfInterest IS NULL THEN 1 ELSE [dbo].[CheckValueInList](PPOI.[IdPointOfInterest], @IdPointsOfInterest) END) > 0
	GROUP BY	C.[Id], C.[Name], C.[Deleted]
	ORDER BY	C.[Name] ASC

	DROP TABLE #ProductIds
END
