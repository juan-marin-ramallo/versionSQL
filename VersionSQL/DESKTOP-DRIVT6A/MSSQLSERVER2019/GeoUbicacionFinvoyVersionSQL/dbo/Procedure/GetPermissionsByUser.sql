/****** Object:  Procedure [dbo].[GetPermissionsByUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 05/11/2012
-- Description:	SP para obtener los permisos de un usuario dado
-- =============================================
CREATE PROCEDURE [dbo].[GetPermissionsByUser]
(
	@IdUser [sys].[int]
)
AS
BEGIN
	SELECT	P.[Id], P.[Description]
	FROM	[dbo].[PermissionTranslated] P WITH (NOLOCK)
			INNER JOIN [dbo].[UserPermission] UP WITH (NOLOCK) ON UP.[IdPermission] = P.[Id]
	WHERE	UP.[IdUser] = @IdUser AND
			P.[Enabled] = 1
END
