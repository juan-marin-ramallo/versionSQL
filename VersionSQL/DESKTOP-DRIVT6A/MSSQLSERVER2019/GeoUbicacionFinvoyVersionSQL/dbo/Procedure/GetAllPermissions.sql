/****** Object:  Procedure [dbo].[GetAllPermissions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 13/11/2017
-- Description:	SP para obtener todos los permisos disponibles
-- =============================================
CREATE PROCEDURE [dbo].[GetAllPermissions]

AS
BEGIN
	SELECT		P.[Id], P.[Description], P.[Enabled], P.[ViewEditEnabled], P.[ViewAllEnabled], P.[ForUsersWithPerson]
	FROM		[dbo].[PermissionTranslated] P WITH (NOLOCK)
	WHERE		P.[Enabled] = 1
	ORDER BY	P.[Order] asc
END
