/****** Object:  Procedure [dbo].[GetUserTypePermissions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/08/2014
-- Description:	SP para obtener los permisos de un tipo de usuario
-- =============================================
CREATE PROCEDURE [dbo].[GetUserTypePermissions]
(
	@UserType [sys].[int] = NULL
)
AS
BEGIN
	SELECT		UTP.[IdUserType], UTP.[IdPermission], UTP.[View], UTP.[Edit], UTP.[ViewAll]
	FROM		[dbo].[UserTypePermission] UTP WITH (NOLOCK)
				INNER JOIN [dbo].[PermissionTranslated] P WITH (NOLOCK) ON P.[Id] = UTP.[IdPermission]
	WHERE		((@UserType IS NULL) OR (UTP.[IdUserType] = @UserType)) AND
				P.[Enabled] = 1 AND
				P.[ForUsersWithPerson] = 0
	ORDER BY	UTP.[IdUserType], UTP.[IdPermission]
END
