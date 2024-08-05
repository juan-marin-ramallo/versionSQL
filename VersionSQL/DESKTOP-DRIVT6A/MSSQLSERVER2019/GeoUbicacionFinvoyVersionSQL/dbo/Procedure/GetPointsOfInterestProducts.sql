/****** Object:  Procedure [dbo].[GetPointsOfInterestProducts]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointsOfInterestProducts]     
 @IdsPointOfInterest [dbo].[IdTableType] READONLY    
AS    
BEGIN    
 DECLARE @EnabledActions sys.int = (SELECT COUNT(1) FROM dbo.PersonOfInterestPermission WHERE [Enabled] = 1 AND CatalogPointAssignation = 1)    
    
 ;WITH     
 vPointPermissions(IdPointOfInterest, IdPersonOfInterestPermission)AS -- Puntos y acciones que tiene asociadas    
 (    
  SELECT IDP.Id as IdPointOfInterest, CPP.IdPersonOfInterestPermission    
  FROM @IdsPointOfInterest IDP     
   INNER JOIN [dbo].[ProductPointOfInterest] PP WITH(NOLOCK) ON IDP.Id  = PP.IdPointOfInterest    
   INNER JOIN [dbo].[Product] P WITH(NOLOCK) ON P.[Id] = PP.[IdProduct]    
   INNER JOIN dbo.CatalogPersonOfInterestPermission CPP WITH(NOLOCK) ON PP.IdCatalog = CPP.IdCatalog    
  WHERE P.[Deleted] = 0    
  GROUP BY IDP.Id, CPP.IdPersonOfInterestPermission      
 ),    
 vPointHasAllProducts(IdPointOfInterest, AllActions, GeneralAction) AS -- Reconocer casoso en los que siempre hay que filtrar    
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
 ),    
 vPointPermissionsGeneral(IdPointOfInterest, IdPersonOfInterestPermission)AS -- se agrega caso NULL (general) si no hay de todas las acciones o si hay general    
 (    
  SELECT PP.IdPointOfInterest, PP.IdPersonOfInterestPermission    
  FROM vPointPermissions PP    
  UNION    
  SELECT PAP.IdPointOfInterest, IIF(GeneralAction = 1, 0, NULL) AS IdPersonOfInterestPermission -- Si tiene accion general se tiene que filtrar siempre, si no solo traer los que tienen attr estrella    
  FROM vPointHasAllProducts PAP     
  WHERE AllActions = 0 OR GeneralAction = 1     
 ),     
  --select * from vPointPermissionsGeneral    
 vProductPoint(IdProduct, IdPointOfInterest)AS    
 (    
  SELECT P.Id as IdProduct, IDP.Id IdPointOfInterest    
  FROM @IdsPointOfInterest IDP,    
   [dbo].[Product] P WITH(NOLOCK)    
  WHERE P.Deleted = 0    
 )    
 -- [IdPersonOfInterestPermission]    
 -- N si tiene IdPersonOfInterestPermission    
 -- 0 si asignación MustHaveAssociation    
 -- NULL si sin asignacion hay star value    
 SELECT P.[IdPointOfInterest], P.[IdProduct], ISNULL(PPOI.[TheoricalStock], 0) AS TheoricalStock, ISNULL(PPOI.[TheoricalPrice], 0) AS TheoricalPrice, PPOI.[Dynamic],    
   PRL.[IdProductReportAttribute], PRL.[Value] AS ProductReportAttributeValue, PRA.[IsStar] AS ProductReportAttributeIsStar, PRA.[IdType] AS ProductReportAttributeType,
   VPP.[IdPersonOfInterestPermission],    
   CPRS.IdProductReportSection  
 FROM vProductPoint P WITH(NOLOCK)    
   LEFT OUTER JOIN [dbo].[ProductPointOfInterest] PPOI WITH (NOLOCK) ON PPOI.[IdProduct] = P.[IdProduct] AND PPOI.[IdPointOfInterest] = P.[IdPointOfInterest]    
   LEFT OUTER JOIN [dbo].[CatalogPersonOfInterestPermission] CSP WITH(NOLOCK)  ON PPOI.[IdCatalog] =  CSP.[IdCatalog]    
   INNER JOIN vPointPermissionsGeneral VPP ON P.IdPointOfInterest = VPP.IdPointOfInterest     
       AND (CSP.IdPersonOfInterestPermission = VPP.IdPersonOfInterestPermission    
        OR VPP.IdPersonOfInterestPermission IS NULL     
        OR (VPP.IdPersonOfInterestPermission = 0 AND CSP.IdPersonOfInterestPermission IS NULL AND PPOI.IdProduct IS NOT NULL))           
        --OR (VPP.IdPersonOfInterestPermission IS NULL AND (VPP.MustHaveAssociation = 0 OR (CSP.IdPersonOfInterestPermission IS NULL AND PPOI.IdProduct IS NOT NULL))))            
   LEFT OUTER JOIN [dbo].[ProductReportLastStarAttributeValue] PRL  WITH (NOLOCK)    
    ON PRL.[IdProduct] = P.[IdProduct] AND PRL.IdPointOfInterest = P.IdPointOfInterest     
   LEFT OUTER JOIN [dbo].[ProductReportAttribute] PRA WITH (NOLOCK)    
       ON PRL.[IdProductReportAttribute] = PRA.[Id] AND PRA.[Deleted] = 0
   LEFT OUTER JOIN [dbo].[CatalogProductReportSection] CPRS ON PPOI.IdCatalog = CPRS.IdCatalog AND ((VPP.IdPersonOfInterestPermission IS NULL) OR VPP.IdPersonOfInterestPermission = 0 OR VPP.IdPersonOfInterestPermission IN (7, 23, 34))  
 WHERE (VPP.[IdPersonOfInterestPermission] IS NOT NULL OR PRL.[IdProductReportAttribute] IS NOT NULL)
	AND (PRL.IdProductReportAttribute IS NULL OR (PRL.IdProductReportAttribute IS NOT NULL AND PRA.Id IS NOT NULL))
 ORDER BY P.IdPointOfInterest, P.[IdProduct], PRL.[IdProductReportAttribute], CSP.[IdPersonOfInterestPermission]    
END
