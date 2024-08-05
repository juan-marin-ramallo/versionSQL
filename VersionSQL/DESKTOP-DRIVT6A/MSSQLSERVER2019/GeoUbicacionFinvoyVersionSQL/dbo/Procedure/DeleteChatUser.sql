/****** Object:  Procedure [dbo].[DeleteChatUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 06/03/2018
-- Description:	SP para eliminar un usuario de chat
-- =============================================
CREATE PROCEDURE [dbo].[DeleteChatUser] 
	@Id [sys].[int]
AS
BEGIN
	UPDATE	[dbo].[ChatUser]
	SET		[Deleted] = 1, [DeletedDate] = GETUTCDATE()
	WHERE	[Id] = @Id
END
