/****** Object:  Procedure [dbo].[GetPointOfInterestProducts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointOfInterestProducts] 
	@IdPointOfInterest [sys].[int]
AS
BEGIN
	DECLARE @EnabledActions sys.int = (SELECT COUNT(1) FROM dbo.PersonOfInterestPermission WHERE [Enabled] = 1 AND CatalogPointAssignation = 1)
	DECLARE @PointActions sys.int = (SELECT COUNT(DISTINCT(PPP.Id))
									FROM [dbo].[ProductPointOfInterest] PP WITH(NOLOCK)
										INNER JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PP.[IdProduct]
										INNER JOIN dbo.CatalogPersonOfInterestPermission CPP WITH(NOLOCK) ON PP.IdCatalog = CPP.IdCatalog
										INNER JOIN dbo.PersonOfInterestPermission PPP WITH(NOLOCK) ON CPP.IdPersonOfInterestPermission = PPP.Id
									WHERE PP.[IdPointOfInterest] = @IdPointOfInterest AND P.[Deleted] = 0)

	-- Si tiene para todas las aciones 
	--  O tiene algun producto fuera de catalogos o algun catalogo sin acción
	-- -> Se obtienen de ProdPoint, nunca van a estar todos
	IF  @EnabledActions = @PointActions 
		OR EXISTS (SELECT TOP(1) 1 FROM [dbo].[ProductPointOfInterest] PP WITH(NOLOCK)
							INNER JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PP.[IdProduct]
							LEFT OUTER JOIN dbo.CatalogPersonOfInterestPermission CPP WITH(NOLOCK) ON PP.IdCatalog = CPP.IdCatalog
					WHERE PP.[IdPointOfInterest] = @IdPointOfInterest AND P.[Deleted] = 0 AND (PP.IdCatalog IS NULL OR CPP.Id IS NULL ))
	BEGIN

		SELECT	P.[Id],	PPOI.[TheoricalStock], PPOI.[TheoricalPrice],
				PRL.[IdProductReportAttribute], PRL.[Value] AS ProductReportAttributeValue,
				PIP.Id AS [IdPersonOfInterestPermission], PPOI.Id AS ProductPointOfInterestId --CSP.
		FROM	[dbo].[Product] P WITH (NOLOCK)
				INNER JOIN [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK) ON PPOI.[IdProduct] = P.[Id] AND PPOI.[IdPointOfInterest] = @IdPointOfInterest
				LEFT OUTER JOIN [dbo].[ProductReportLastStarAttributeValue] PRL WITH (NOLOCK) 
					ON PRL.[IdPointOfInterest] = PPOI.[IdPointOfInterest] AND PRL.[IdProduct] = PPOI.[IdProduct]
				AND EXISTS (SELECT 1 FROM [dbo].[ProductReportAttribute] PRA WITH (NOLOCK)
				WHERE PRL.[IdProductReportAttribute] = PRA.[Id] AND PRA.[IsStar] = 1 AND PRA.[Deleted] = 0)
			LEFT OUTER JOIN [dbo].[CatalogPersonOfInterestPermission] CSP WITH(NOLOCK)  ON PPOI.[IdCatalog] =  CSP.[IdCatalog]
			LEFT OUTER JOIN [dbo].[PersonOfInterestPermission] PIP WITH(NOLOCK) ON PIP.[Id] = CSP.IdPersonOfInterestPermission OR (CSP.IdPersonOfInterestPermission IS NULL AND @EnabledActions = @PointActions AND PIP.[Enabled] = 1 AND PIP.CatalogPointAssignation = 1)
 		WHERE	PPOI.[IdPointOfInterest] = @IdPointOfInterest AND P.[Deleted] = 0
		ORDER BY P.[Id], PRL.[IdProductReportAttribute], CSP.[IdPersonOfInterestPermission]

	END
	-- -> Algunas acciones solo tienen unos prods, el resto todos
	ELSE IF @PointActions > 0
	BEGIN

		SELECT	P.[Id],	ISNULL(PPOI.[TheoricalStock], 0) AS TheoricalStock, ISNULL(PPOI.[TheoricalPrice], 0) AS TheoricalPrice,
				PRL.[IdProductReportAttribute], PRL.[Value] AS ProductReportAttributeValue,
				CSP.[IdPersonOfInterestPermission], PPOI.Id AS ProductPointOfInterestId
		FROM	[dbo].[Product] P
				LEFT OUTER JOIN [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK) ON PPOI.[IdProduct] = P.[Id] AND PPOI.[IdPointOfInterest] = @IdPointOfInterest
				LEFT OUTER JOIN [dbo].[ProductReportLastStarAttributeValue] PRL  WITH (NOLOCK)
					ON PRL.[IdProduct] = P.[Id] 
					AND EXISTS (SELECT 1 FROM [dbo].[ProductReportAttribute] PRA WITH (NOLOCK)
				WHERE PRL.[IdProductReportAttribute] = PRA.[Id] AND PRA.[IsStar] = 1 AND PRA.[Deleted] = 0)
				LEFT OUTER JOIN [dbo].[CatalogPersonOfInterestPermission] CSP WITH(NOLOCK)  ON PPOI.[IdCatalog] =  CSP.[IdCatalog]
		WHERE	P.[Deleted] = 0
		ORDER BY P.[Id], PRL.[IdProductReportAttribute], CSP.[IdPersonOfInterestPermission]

	END
	ELSE 
	BEGIN
	-- -> Se obtiene todos los productos

		SELECT	P.[Id],	0 AS TheoricalStock, 0 AS TheoricalPrice,
				PRL.[IdProductReportAttribute], PRL.[Value] AS ProductReportAttributeValue,
				NULL AS [IdPersonOfInterestPermission], NULL AS ProductPointOfInterestId
		FROM	[dbo].[Product] P
				LEFT OUTER JOIN [dbo].[ProductReportLastStarAttributeValue] PRL 
					ON PRL.[IdPointOfInterest] = @IdPointOfInterest AND PRL.[IdProduct] = P.[Id] 
					AND EXISTS (SELECT 1 FROM [dbo].[ProductReportAttribute] PRA
				WHERE PRL.[IdProductReportAttribute] = PRA.[Id] AND PRA.[IsStar] = 1 AND PRA.[Deleted] = 0)

		WHERE	P.[Deleted] = 0
		ORDER BY P.[Id], PRL.[IdProductReportAttribute]

	END

END
