/****** Object:  Procedure [dbo].[GetScheduleProfileSKUsectionsForTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================================================
-- Author:		Juan Marin
-- Create date: 01/04/2024
-- Description:	SP para obtener la informacion de las Secciones de SKU disponibles a mostrar en el Cronograma de Actividades
-- =============================================================================
CREATE PROCEDURE [dbo].[GetScheduleProfileSKUsectionsForTemplate] 
AS
BEGIN
	SELECT	[Name], Id
	FROM	dbo.ProductReportSection WITH (NOLOCK)
	WHERE	Deleted = 0
	ORDER BY [Order]
END
