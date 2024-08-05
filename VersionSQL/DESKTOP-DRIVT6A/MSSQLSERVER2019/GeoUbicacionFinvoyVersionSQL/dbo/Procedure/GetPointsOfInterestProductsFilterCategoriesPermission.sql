/****** Object:  Procedure [dbo].[GetPointsOfInterestProductsFilterCategoriesPermission]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointsOfInterestProductsFilterCategoriesPermission]		
	 @IdPointOfInterest [sys].[int] = NULL
	,@IdPersonOfInterestPermission [sys].[int] = NULL
	,@IdsProductCategory [dbo].[IdTableType] READONLY
	,@IncludeDeleted bit = 0
AS 
BEGIN
    SET NOCOUNT ON;
	DECLARE @EnabledActions sys.int = (SELECT COUNT(1) FROM dbo.PersonOfInterestPermission WHERE [Enabled] = 1 AND CatalogPointAssignation = 1)    
	DECLARE @AnyAssignation sys.bit = (SELECT  IIF (EXISTS 
														(SELECT 1    
														FROM [dbo].[ProductPointOfInterest] PP WITH(NOLOCK)
															INNER JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PP.[IdProduct] AND P.[Deleted] = 0																	    
														WHERE PP.IdPointOfInterest = @IdPointOfInterest)
												, 1, 0))
	DECLARE @AnyProductWithPersonOfInterestPermission [sys].[bit] = (
												SELECT IIF (@AnyAssignation = 1 AND EXISTS 
														(SELECT 1    
														FROM [dbo].[ProductPointOfInterest] PP WITH(NOLOCK)
															INNER JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PP.[IdProduct] AND P.[Deleted] = 0
															INNER JOIN [dbo].[CatalogPersonOfInterestPermission] CPP WITH(NOLOCK) 
																ON PP.IdCatalog = CPP.IdCatalog AND CPP.IdPersonOfInterestPermission = @IdPersonOfInterestPermission																	    
														WHERE PP.IdPointOfInterest = @IdPointOfInterest)
													, 1, 0))
	 declare @IdsPointOfInterest [dbo].[IdTableType]   
	 insert into @IdsPointOfInterest(Id) VALUES (@IdPointOfInterest)

	;WITH     
	vPointPermissions(IdPointOfInterest, IdPersonOfInterestPermission)AS -- Puntos y acciones que tiene asociadas    
	(    
	SELECT PP.IdPointOfInterest, CPP.IdPersonOfInterestPermission    
	FROM [dbo].[ProductPointOfInterest] PP WITH(NOLOCK)
		INNER JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PP.[IdProduct] AND P.[Deleted] = 0     
		INNER JOIN dbo.CatalogPersonOfInterestPermission CPP WITH(NOLOCK) ON PP.IdCatalog = CPP.IdCatalog    
	WHERE PP.IdPointOfInterest = @IdPointOfInterest
	GROUP BY PP.IdPointOfInterest, CPP.IdPersonOfInterestPermission      
	)
	,vPointHasAllProducts(IdPointOfInterest, AllActions, GeneralAction) AS -- Reconocer casoso en los que siempre hay que filtrar    
	(    
	  SELECT IDP.Id AS IdPointOfInterest    
		, IIF(@EnabledActions = COUNT(VPP.IdPersonOfInterestPermission), 1, 0) AS AllActions -- Todas las acciones, siempre filtro productos asociados    
		, IIF( EXISTS (SELECT TOP(1) 1 FROM [dbo].[ProductPointOfInterest] PP WITH(NOLOCK)    
		   INNER JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PP.[IdProduct]    
		   LEFT OUTER JOIN dbo.CatalogPersonOfInterestPermission CPP WITH(NOLOCK) ON PP.IdCatalog = CPP.IdCatalog    
		 WHERE PP.[IdPointOfInterest] = IDP.Id AND P.[Deleted] = 0 AND (PP.IdCatalog IS NULL OR CPP.IdCatalog IS NULL)), 1, 0) AS GeneralAction -- Producto asociado a todo, siempre filtro productos asociados    
	  FROM @IdsPointOfInterest IDP     
	   LEFT OUTER JOIN vPointPermissions VPP ON IDP.Id = VPP.IdPointOfInterest    
	  GROUP BY IDP.Id  
	)
	,vPointPermissionsGeneral(IdPointOfInterest, IdPersonOfInterestPermission)AS -- se agrega caso NULL (general) si no hay de todas las acciones o si hay general    
	(    
	SELECT PP.IdPointOfInterest, PP.IdPersonOfInterestPermission    
	FROM vPointPermissions PP    
	UNION    
	SELECT PAP.IdPointOfInterest, IIF(GeneralAction = 1, 0, NULL) AS IdPersonOfInterestPermission -- Si tiene accion general se tiene que filtrar siempre, si no solo traer los que tienen attr estrella    
	FROM vPointHasAllProducts PAP     
	WHERE AllActions = 0 OR GeneralAction = 1     
	)
	,vProductPoint(IdProduct, Name, Identifier, IdProductBrand, IdPointOfInterest)AS    
	(    
	SELECT P.Id as IdProduct, P.Name, p.Identifier, P.IdProductBrand, @IdPointOfInterest AS IdPointOfInterest    
	FROM [dbo].[Product] P WITH(NOLOCK)    
		INNER JOIN dbo.ProductCategoryList PCL on P.Id = PCL.IdProduct
		INNER JOIN @IdsProductCategory PC ON PCL.IdProductCategory = PC.Id
	WHERE P.Deleted = 0    
	)
	-- [IdPersonOfInterestPermission]    
	-- N si tiene IdPersonOfInterestPermission    
	-- 0 si asignación MustHaveAssociation                                                                                                            
	-- NULL si sin asignacion hay star value    
	,vProductPermission(IdProduct, Name, Identifier, IdProductBrand, IdPersonOfInterestPermission) AS
	(
	SELECT P.[IdProduct], P.Name, p.Identifier, P.IdProductBrand, ISNULL(VPP.[IdPersonOfInterestPermission], 0)
	FROM vProductPoint P WITH(NOLOCK)    
		LEFT OUTER JOIN [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK) ON PPOI.[IdProduct] = P.[IdProduct] AND PPOI.[IdPointOfInterest] = P.[IdPointOfInterest]    
		LEFT OUTER JOIN [dbo].[CatalogPersonOfInterestPermission] CSP WITH(NOLOCK)  ON PPOI.[IdCatalog] =  CSP.[IdCatalog]    --borrar
		LEFT OUTER JOIN vPointPermissionsGeneral VPP ON P.IdPointOfInterest = VPP.IdPointOfInterest     
			AND (CSP.IdPersonOfInterestPermission = VPP.IdPersonOfInterestPermission    
			OR VPP.IdPersonOfInterestPermission IS NULL     
			OR (VPP.IdPersonOfInterestPermission = 0 AND CSP.IdPersonOfInterestPermission IS NULL AND PPOI.IdProduct IS NOT NULL))           
			-- --OR (VPP.IdPersonOfInterestPermission IS NULL AND (VPP.MustHaveAssociation = 0 OR (CSP.IdPersonOfInterestPermission IS NULL AND PPOI.IdProduct IS NOT NULL))))              
	WHERE @AnyAssignation = 0 OR (@AnyAssignation = 1 AND (VPP.[IdPersonOfInterestPermission] = @IdPersonOfInterestPermission OR VPP.[IdPersonOfInterestPermission] = 0))
	)
	SELECT P.[IdProduct], P.Name, p.Identifier, P.IdProductBrand
	FROM vProductPermission P
	WHERE P.[IdPersonOfInterestPermission] = @IdPersonOfInterestPermission OR @AnyProductWithPersonOfInterestPermission = 0 OR @AnyAssignation = 0
	GROUP BY P.IdProduct, P.[Name], p.Identifier, P.IdProductBrand
	ORDER BY P.IdProduct
END
