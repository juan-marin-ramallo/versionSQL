/****** Object:  Procedure [dbo].[DeleteUserType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 13/07/2017
-- Description:	SP para ELIMINAR un tipo de usuario
-- =============================================
CREATE PROCEDURE [dbo].[DeleteUserType]
(
	 @Id [sys].[int]
)
AS
BEGIN

	--DELETE FROM [dbo].[UserPermission] where [IdUser] in (SELECT [Id] FROM [dbo].[User] WHERE [Type] = @Id)

	UPDATE	[dbo].[User]
	SET		[Type] = NULL
	WHERE	[Type] = @Id

	DELETE FROM [dbo].[UserTypePermission] WHERE [IdUserType] = @Id

	DELETE FROM [dbo].[UserType] WHERE	[Id] = @Id

END
