/****** Object:  Procedure [dbo].[DeleteUserDepartments]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 20/11/2012
-- Description:	SP para eliminar los departamentos de un usuario
-- =============================================
CREATE PROCEDURE [dbo].[DeleteUserDepartments]
(
	 @IdUser [sys].[int]
)
AS
BEGIN
	DELETE FROM	[dbo].[UserDepartment]
	WHERE		IdUser = @IdUser
END
