/****** Object:  Procedure [dbo].[BackupDeleteMessageReplyUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupDeleteMessageReplyUser]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  DELETE a
  FROM [dbo].MessageReplyUser a WITH(NOLOCK)
	INNER JOIN [dbo].[MessageReply] b WITH(NOLOCK)  ON a.IdMessageReply = b.Id
	INNER JOIN [dbo].[Message] c WITH(NOLOCK) ON b.IdMessage = c.Id
  WHERE c.[Date] < @LimitDate
END
