/****** Object:  Procedure [dbo].[GetCatalogsForTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================================================
-- Author:		Juan Marin
-- Create date: 01/04/2024
-- Description:	SP para obtener la informacion de los Catalogos de Productos disponibles a mostrar en el Cronograma de Actividades
-- =============================================================================
CREATE PROCEDURE [dbo].[GetCatalogsForTemplate] 
AS
BEGIN
	SELECT	Id, [Name]
	FROM	dbo.[Catalog] WITH (NOLOCK)
	WHERE	Deleted = 0
	ORDER BY [Name]
END
