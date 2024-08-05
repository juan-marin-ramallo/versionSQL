/****** Object:  Procedure [dbo].[DeleteUserPermissions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 05/11/2012
-- Description:	SP para eliminar los permisos de un usuario
-- =============================================
CREATE PROCEDURE [dbo].[DeleteUserPermissions]
(
	 @IdUser [sys].[int]
)
AS
BEGIN
	DELETE FROM	[dbo].[UserPermission]
	WHERE		IdUser = @IdUser
END
