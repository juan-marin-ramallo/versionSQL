/****** Object:  Procedure [dbo].[GetScheduleProfileCatalogsByPointOfInterestForTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================================================
-- Author:		Juan Marin
-- Create date: 01/04/2024
-- Description:	SP para obtener la informacion de los Catalogos de Productos por Punto de Interés con Acciones disponibles a mostrar en el Cronograma de Actividades
-- =============================================================================
CREATE PROCEDURE [dbo].[GetScheduleProfileCatalogsByPointOfInterestForTemplate] 
AS
BEGIN
	 SELECT DISTINCT POI.Identifier AS PointOfInterestIdentifier, C.[Name] AS [Catalog], POIP.[Description] AS [Action]
	 FROM dbo.[Catalog] AS C WITH (NOLOCK)  
	 INNER JOIN   
	   dbo.CatalogPersonOfInterestPermission AS CPOIP WITH (NOLOCK) ON CPOIP.IdCatalog = C.Id
	 INNER JOIN  
	   dbo.CatalogPointOfInterest AS CPOI WITH (NOLOCK) ON CPOI.IdCatalog = C.Id  
	 INNER JOIN
	   dbo.PointOfInterest POI WITH (NOLOCK) ON POI.Id = CPOI.IdPointOfInterest 
	 INNER JOIN  
	   dbo.PersonOfInterestPermission AS POIP WITH (NOLOCK) ON POIP.Id = CPOIP.IdPersonOfInterestPermission
	 WHERE C.Deleted = 0   
	 ORDER BY 1,2,3
END
