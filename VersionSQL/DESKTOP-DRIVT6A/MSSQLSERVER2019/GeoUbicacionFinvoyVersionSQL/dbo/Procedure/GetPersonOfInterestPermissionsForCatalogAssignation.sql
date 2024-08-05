/****** Object:  Procedure [dbo].[GetPersonOfInterestPermissionsForCatalogAssignation]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 20/08/2019
-- Description:	SP para obtener las acciones a las cuales se pueden asignar catalogos por puntos.

-- =============================================
CREATE PROCEDURE [dbo].[GetPersonOfInterestPermissionsForCatalogAssignation]

AS
BEGIN

	SELECT	P.[Id], P.[Description], P.[PermissionSet]
	FROM	[dbo].[PersonOfInterestPermissionTranslated] P with(nolock)
	WHERE	P.[Enabled] = 1 AND [CatalogPointAssignation] = 1
	ORDER BY P.[Order], P.[Id]
	
END
