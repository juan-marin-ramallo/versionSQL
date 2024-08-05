/****** Object:  Procedure [dbo].[GetProductsFormsPlusByPersonAndPoint]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 18/04/2023
-- Description:	SP para obtener los productos y
--				los formularios asociados, dada
--				una persona de interés y un
--				puntos de interés
-- =============================================
CREATE PROCEDURE [dbo].[GetProductsFormsPlusByPersonAndPoint]
(
	 @IdPersonOfInterest [sys].[int]
	,@IdPointOfInterest [sys].[int]
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT		P.[Id] AS IdProduct, FP.[IdForm] AS IdFormPlus

	FROM		[dbo].[FormPlus] FP WITH (NOLOCK)
				INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = FP.[IdForm]
				INNER JOIN [dbo].[AssignedForm] AF WITH (NOLOCK) ON AF.[IdForm] = F.[Id]
				INNER JOIN [dbo].[FormPlusProduct] FPP WITH (NOLOCK) ON FPP.[IdFormPlus] = FP.[Id]
				INNER JOIN [dbo].[Product] P WITH (NOLOCK) ON P.[Id] = FPP.[IdProduct] AND P.[Deleted] = 0
	
	WHERE		F.[Deleted] = 0 AND FP.[Deleted] = 0
				AND (F.[AllPersonOfInterest] = 1 OR AF.[IdPersonOfInterest] = @IdPersonOfInterest)
				AND (F.[AllPointOfInterest] = 1 OR AF.[IdPointOfInterest] = @IdPointOfInterest)
	
	GROUP BY	P.[Id], FP.[IdForm]

	UNION

	SELECT		P.[Id] AS IdProduct, FP.[IdForm] AS IdFormPlus

	FROM		[dbo].[FormPlus] FP WITH (NOLOCK)
				INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = FP.[IdForm]
				INNER JOIN [dbo].[AssignedForm] AF WITH (NOLOCK) ON AF.[IdForm] = F.[Id]
				INNER JOIN [dbo].[FormPlusCatalog] FPC WITH (NOLOCK) ON FPC.[IdFormPlus] = FP.[Id]
				INNER JOIN [dbo].[Catalog] C WITH (NOLOCK) ON C.[Id] = FPC.[IdCatalog] AND C.[Deleted] = 0
				INNER JOIN [dbo].[CatalogProduct] CP WITH (NOLOCK) ON CP.[IdCatalog] = C.[Id]
				INNER JOIN [dbo].[Product] P WITH (NOLOCK) ON P.[Id] = CP.[IdProduct] AND P.[Deleted] = 0
				LEFT JOIN [dbo].[CatalogPersonOfInterestPermission] CPOIP WITH (NOLOCK) ON CPOIP.[IdCatalog] = C.[Id]
	
	WHERE		F.[Deleted] = 0 AND FP.[Deleted] = 0
				AND (F.[AllPersonOfInterest] = 1 OR AF.[IdPersonOfInterest] = @IdPersonOfInterest)
				AND (F.[AllPointOfInterest] = 1 OR AF.[IdPointOfInterest] = @IdPointOfInterest)
				AND (CPOIP.[Id] IS NULL OR CPOIP.[IdPersonOfInterestPermission] = 35) -- All actions or has Forms permission
	
	GROUP BY	P.[Id], FP.[IdForm]
	
	ORDER BY	IdProduct, IdFormPlus
END
