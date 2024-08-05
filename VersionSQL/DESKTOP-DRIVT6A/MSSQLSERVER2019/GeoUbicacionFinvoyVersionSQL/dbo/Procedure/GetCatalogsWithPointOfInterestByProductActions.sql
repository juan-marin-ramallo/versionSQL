/****** Object:  Procedure [dbo].[GetCatalogsWithPointOfInterestByProductActions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author: Juan Marin 
-- Create date: 12/Ene/2024
-- Description: Devuelve los catalogos relaciones a Acciones (Permisos) de productos y que tengan punto de interes  
-- =============================================  
CREATE PROCEDURE [dbo].[GetCatalogsWithPointOfInterestByProductActions]   
  @ProductActionPoiPermissionIds [sys].[VARCHAR](MAX)    
AS   
BEGIN    
    SET NOCOUNT ON;   

	SELECT	DISTINCT C.Id, C.[Name] 
	FROM	dbo.[Catalog] AS C WITH (NOLOCK)
	INNER JOIN	
			dbo.CatalogPersonOfInterestPermission AS CPOIP WITH (NOLOCK) ON CPOIP.IdCatalog = C.Id AND CPOIP.IdPersonOfInterestPermission IN (7, 23, 4, 15, 32, 28) --Control Sku Unitario, Control Sku Masivo, Devoluciones, Faltantes, Toma de Pedidos, Share of Shelf(Participacion de Gondola) 
	INNER JOIN
			dbo.CatalogPointOfInterest AS CPOI WITH (NOLOCK) ON CPOI.IdCatalog = C.Id
	WHERE	C.Deleted = 0 
	AND		dbo.CheckValueInList (CPOIP.IdPersonOfInterestPermission, @ProductActionPoiPermissionIds) = 1 
	ORDER BY C.[Name]
END
