/****** Object:  Procedure [dbo].[GetAllPersonOfInterestPermissions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 20/04/2015
-- Description:	SP para obtener los permisos para personas de interés
-- Change: Matias Corso - 17/11/16 - Agrego PersmissionSet
-- =============================================
CREATE PROCEDURE [dbo].[GetAllPersonOfInterestPermissions]

AS
BEGIN
	SELECT P.[Id], P.[Description], P.[PermissionSet]
	FROM [dbo].[PersonOfInterestPermissionTranslated] P WITH (NOLOCK)
	WHERE P.[Enabled] = 1
	ORDER BY P.[Order], P.[Id]
END
