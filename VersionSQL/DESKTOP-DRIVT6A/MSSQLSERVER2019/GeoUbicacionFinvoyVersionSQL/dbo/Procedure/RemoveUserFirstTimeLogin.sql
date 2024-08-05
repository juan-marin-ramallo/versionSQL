/****** Object:  Procedure [dbo].[RemoveUserFirstTimeLogin]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 07/11/2012
-- Description:	SP para quitar la verificación de primer login de un usuario
-- =============================================
CREATE PROCEDURE [dbo].[RemoveUserFirstTimeLogin]
(
	  @IdUser [sys].[int]
	 ,@NewPassword [sys].[varchar](100)
)
AS
BEGIN
	UPDATE	 [dbo].[User]
	SET		 [FirstTimeLogin] = 0, [ChangePassword] = 0
			,[Password] = @NewPassword
	WHERE	 [Id] = @IdUser
END
