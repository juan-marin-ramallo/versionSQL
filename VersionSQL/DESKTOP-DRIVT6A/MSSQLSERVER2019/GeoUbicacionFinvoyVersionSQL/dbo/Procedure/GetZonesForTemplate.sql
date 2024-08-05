/****** Object:  Procedure [dbo].[GetZonesForTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================================================
-- Author:		Juan Marin
-- Create date: 01/04/2024
-- Description:	SP para obtener la informacion de las Agrupaciones por Zona disponibles a mostrar en el Cronograma de Actividades
-- =============================================================================
CREATE PROCEDURE [dbo].[GetZonesForTemplate] 
AS
BEGIN
	SELECT	Id, [Description]
	FROM	dbo.[Zone] WITH (NOLOCK) 
	WHERE	ApplyToAllPersonOfInterest <> 1
	AND		ApplyToAllPointOfInterest <> 1
	ORDER BY 1	
END
