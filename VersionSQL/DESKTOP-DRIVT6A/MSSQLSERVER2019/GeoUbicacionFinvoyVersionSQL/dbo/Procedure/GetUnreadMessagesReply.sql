/****** Object:  Procedure [dbo].[GetUnreadMessagesReply]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 06/02/2013
-- Description:	SP para marcar un mensaje como leído
-- =============================================
CREATE PROCEDURE [dbo].[GetUnreadMessagesReply]
(
	@IdUser [sys].[int]
)
AS
BEGIN

	SELECT COUNT(IdMessageReply)	
	
	FROM		[dbo].[MessageReplyUser] MRU
	INNER JOIN	[dbo].[MessageReply] MR ON MR.[Id] = MRU.[IdMessageReply]
	INNER JOIN	[dbo].[Message] M ON M.[Id] = MR.[IdMessage]
	
	WHERE		MRU.[IdUser] = @IdUser AND M.[Deleted] = 0
END
