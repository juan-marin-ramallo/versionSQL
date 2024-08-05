/****** Object:  Procedure [dbo].[DeleteUserTypePermissions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 14/07/2017
-- Description:	SP para eliminar los permisos de un tipo de usuario
-- =============================================
CREATE PROCEDURE [dbo].[DeleteUserTypePermissions]
(
	 @IdUserType [sys].[int]
)
AS
BEGIN
	DELETE FROM	[dbo].[UserTypePermission]
	WHERE		IdUserType = @IdUserType
END
