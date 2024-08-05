/****** Object:  Procedure [dbo].[GetUserPermissions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 05/11/2012
-- Description:	SP para obtener los permisos de un usuario dado
-- =============================================
CREATE PROCEDURE [dbo].[GetUserPermissions]
(
	@IdUser [sys].[int]
)
AS
BEGIN
	SELECT		UP.[IdUser], UP.[IdPermission], P.[Description], P.[Enabled], P.[ViewEditEnabled], UP.[CanView], 
				UP.[CanEdit], P.[ViewAllEnabled], UP.[CanViewAll], P.[ForUsersWithPerson]
	FROM		[dbo].[UserPermission] AS UP WITH (NOLOCK)
				INNER JOIN [dbo].[PermissionTranslated] as P WITH (NOLOCK) ON (UP.[IdPermission] = P.[Id])
	WHERE		UP.[IdUser] = @IdUser AND
				P.[Enabled] = 1
	ORDER BY	P.[Order] asc
END
