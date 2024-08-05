/****** Object:  Procedure [dbo].[GetScheduleProfileCatalogsWithActionsAndSKUsectionsForTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================================================
-- Author:		Juan Marin
-- Create date: 01/04/2024
-- Description:	SP para obtener la informacion de los Catalogos de Productos con Acciones y Secciones de SKU disponibles a mostrar en el Cronograma de Actividades
-- =============================================================================
CREATE PROCEDURE [dbo].[GetScheduleProfileCatalogsWithActionsAndSKUsectionsForTemplate] 
AS
BEGIN
	 SELECT DISTINCT C.[Name] AS [Catalog], POIP.[Description] AS [Action], PRS.[Name] AS SKUsection
	 FROM	dbo.[Catalog] AS C WITH (NOLOCK)  
	 INNER JOIN   
			dbo.CatalogPersonOfInterestPermission AS CPOIP WITH (NOLOCK) ON CPOIP.IdCatalog = C.Id
	 INNER JOIN  
			dbo.PersonOfInterestPermission AS POIP WITH (NOLOCK) ON POIP.Id = CPOIP.IdPersonOfInterestPermission
	 LEFT JOIN  
			dbo.CatalogProductReportSection AS CPRS WITH (NOLOCK) ON CPRS.IdCatalog = C.Id
	 LEFT JOIN
			dbo.ProductReportSection PRS WITH (NOLOCK) ON PRS.Id = CPRS.IdProductReportSection AND PRS.Deleted = 0
	 WHERE C.Deleted = 0   
	 ORDER BY 1,2,3
END
