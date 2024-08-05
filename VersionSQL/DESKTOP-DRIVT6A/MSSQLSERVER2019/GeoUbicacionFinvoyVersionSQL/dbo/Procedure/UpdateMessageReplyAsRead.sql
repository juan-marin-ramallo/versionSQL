/****** Object:  Procedure [dbo].[UpdateMessageReplyAsRead]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 06/02/2013
-- Description:	SP para marcar un mensaje como leído
-- =============================================
CREATE PROCEDURE [dbo].[UpdateMessageReplyAsRead]
(
	 @IdMessage [sys].[int]
	,@IdUser [sys].[int]
)
AS
BEGIN
	DELETE	ru
	FROM	[dbo].[MessageReplyUser] ru
			INNER JOIN [dbo].[MessageReply] r ON ru.[IdMessageReply] = r.[Id]
	WHERE	R.[IdMessage] = @IdMessage AND
			ru.[IdUser] = @IdUser

	SELECT COUNT(IdMessageReply)	
	
	FROM		[dbo].[MessageReplyUser] MRU
	INNER JOIN	[dbo].[MessageReply] MR ON MR.[Id] = MRU.[IdMessageReply]
	INNER JOIN	[dbo].[Message] M ON M.[Id] = MR.[IdMessage]
	
	WHERE		MRU.[IdUser] = @IdUser AND M.[Deleted] = 0
END
