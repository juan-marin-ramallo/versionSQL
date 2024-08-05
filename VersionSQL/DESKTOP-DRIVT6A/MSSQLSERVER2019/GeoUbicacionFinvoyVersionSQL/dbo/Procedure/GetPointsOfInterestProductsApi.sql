/****** Object:  Procedure [dbo].[GetPointsOfInterestProductsApi]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointsOfInterestProductsApi] 
	 @IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdAction [sys].[int]
AS
BEGIN

	SELECT	PP.IdPointOfInterest, PP.IdProduct,  
			ISNULL(PP.[TheoricalStock], 0) AS TheoricalStock, ISNULL(PP.[TheoricalPrice], 0) AS TheoricalPrice, CP.IdPersonOfInterestPermission

	FROM	[dbo].[ProductPointOfInterest] PP WITH(NOLOCK) 
			LEFT JOIN [dbo].[Product] P WITH(NOLOCK) ON P.Id = PP.IdProduct
			LEFT JOIN [dbo].[CatalogPersonOfInterestPermission] CP WITH(NOLOCK) ON CP.IdCatalog = PP.IdCatalog

	WHERE	((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(PP.[IdPointOfInterest], @IdPointsOfInterest) = 1)) AND 
			(CP.IdPersonOfInterestPermission IS NULL OR CP.[IdPersonOfInterestPermission] = @IdAction)

	Order BY PP.IdPointOfInterest

	--;WITH 
	--vPointPermissions(IdPointOfInterest, IdPersonOfInterestPermission)AS -- Puntos y acciones que tiene asociadas
	--(
	--	SELECT IDP.Id as IdPointOfInterest, CPP.IdPersonOfInterestPermission
	--	FROM @IdsPointOfInterest IDP 
	--		INNER JOIN [dbo].[ProductPointOfInterest] PP WITH(NOLOCK) ON IDP.Id  = PP.IdPointOfInterest
	--		INNER JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PP.[IdProduct]
	--		INNER JOIN dbo.CatalogPersonOfInterestPermission CPP WITH(NOLOCK) ON PP.IdCatalog = CPP.IdCatalog
	--	WHERE P.[Deleted] = 0
	--	GROUP BY IDP.Id, CPP.IdPersonOfInterestPermission		
	--),
	--vPointHasAllProducts(IdPointOfInterest, AllActions, GeneralAction) AS -- Reconocer casoso en los que siempre hay que filtrar
	--(
	--	SELECT IDP.Id AS IdPointOfInterest
	--			, IIF(@EnabledActions = COUNT(VPP.IdPersonOfInterestPermission), 1, 0) AS AllActions -- Todas las acciones, siempre filtro productos asociados
	--			, IIF( EXISTS (SELECT TOP(1) 1 FROM [dbo].[ProductPointOfInterest] PP WITH(NOLOCK)
	--						INNER JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PP.[IdProduct]
	--						LEFT OUTER JOIN dbo.CatalogPersonOfInterestPermission CPP WITH(NOLOCK) ON PP.IdCatalog = CPP.IdCatalog
	--				WHERE PP.[IdPointOfInterest] = IDP.Id AND P.[Deleted] = 0 AND (PP.IdCatalog IS NULL OR CPP.IdCatalog IS NULL)), 1, 0) AS GeneralAction -- Producto asociado a todo, siempre filtro productos asociados
	--	FROM @IdsPointOfInterest IDP 
	--		LEFT OUTER JOIN vPointPermissions VPP ON IDP.Id = VPP.IdPointOfInterest
	--	GROUP BY IDP.Id
	--),
	--vPointPermissionsGeneral(IdPointOfInterest, IdPersonOfInterestPermission)AS -- se agrega caso NULL (general) si no hay de todas las acciones o si hay general
	--(
	--	SELECT PP.IdPointOfInterest, PP.IdPersonOfInterestPermission
	--	FROM vPointPermissions PP
	--	UNION
	--	SELECT PAP.IdPointOfInterest, IIF(GeneralAction = 1, 0, NULL) AS IdPersonOfInterestPermission -- Si tiene accion general se tiene que filtrar siempre, si no solo traer los que tienen attr estrella
	--	FROM vPointHasAllProducts PAP 
	--	WHERE AllActions = 0 OR GeneralAction = 1	
	--),	
	-- --select * from vPointPermissionsGeneral
	--vProductPoint(IdProduct, IdPointOfInterest)AS
	--(
	--	SELECT P.Id as IdProduct, IDP.Id IdPointOfInterest
	--	FROM @IdsPointOfInterest IDP,
	--		[dbo].[Product] P WITH(NOLOCK)
	--	WHERE P.Deleted = 0
	--)
	---- [IdPersonOfInterestPermission]
	----	N si tiene IdPersonOfInterestPermission
	----	0 si asignación MustHaveAssociation
	----	NULL si sin asignacion hay star value
	--SELECT	P.[IdPointOfInterest], P.[IdProduct], ISNULL(PPOI.[TheoricalStock], 0) AS TheoricalStock, ISNULL(PPOI.[TheoricalPrice], 0) AS TheoricalPrice,
	--		VPP.[IdPersonOfInterestPermission]
	--FROM	vProductPoint P WITH(NOLOCK)
	--		LEFT OUTER JOIN [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK) ON PPOI.[IdProduct] = P.[IdProduct] AND PPOI.[IdPointOfInterest] = P.[IdPointOfInterest]
	--		LEFT OUTER JOIN [dbo].[CatalogPersonOfInterestPermission] CSP WITH(NOLOCK)  ON PPOI.[IdCatalog] =  CSP.[IdCatalog]
	--		INNER JOIN vPointPermissionsGeneral VPP ON P.IdPointOfInterest = VPP.IdPointOfInterest 
	--						AND (CSP.IdPersonOfInterestPermission = VPP.IdPersonOfInterestPermission
	--							OR VPP.IdPersonOfInterestPermission IS NULL 
	--							OR (VPP.IdPersonOfInterestPermission = 0 AND CSP.IdPersonOfInterestPermission IS NULL AND PPOI.IdProduct IS NOT NULL))							
	--WHERE VPP.[IdPersonOfInterestPermission] IS NOT NULL
	--ORDER BY P.IdPointOfInterest, P.[IdProduct], CSP.[IdPersonOfInterestPermission]
END
