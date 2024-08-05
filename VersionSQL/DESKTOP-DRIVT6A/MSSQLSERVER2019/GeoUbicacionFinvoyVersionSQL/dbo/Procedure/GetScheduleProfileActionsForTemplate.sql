/****** Object:  Procedure [dbo].[GetScheduleProfileActionsForTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================================================
-- Author:		Juan Marin
-- Create date: 01/04/2024
-- Description:	SP para obtener la informacion de las Acciones disponibles a mostrar en el Cronograma de Actividades
-- =============================================================================
CREATE PROCEDURE [dbo].[GetScheduleProfileActionsForTemplate] 
AS
BEGIN
	SELECT	[Description], Id, CASE WHEN CatalogPointAssignation = 1 THEN 1 ELSE  0 END AS IsProductPermission
	FROM	dbo.PersonOfInterestPermission WITH (NOLOCK)
	WHERE	ScheduleProfileSelection = 1 AND [Enabled] = 1 
	ORDER BY [Order]
END
