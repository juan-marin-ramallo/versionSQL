/****** Object:  Procedure [dbo].[UpdateChatUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 07/03/2018
-- Description:	SP para actualizar algunos datos de un usuario de chat
-- =============================================
CREATE PROCEDURE [dbo].[UpdateChatUser]
	 @Id [sys].[int]
	,@DisplayName [sys].[varchar](500) = NULL
	,@ImageLink [sys].[varchar](255) = NULL
AS 
BEGIN
	UPDATE	[dbo].[ChatUser]
	SET		[DisplayName] = @DisplayName,
			[ImageLink] = @ImageLink
	WHERE	[Id] = @Id
END
