/****** Object:  Procedure [dbo].[BackupGetMessageReplyUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetMessageReplyUser]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[IdMessageReply],a.[IdUser]
  FROM [dbo].MessageReplyUser a WITH(NOLOCK)
	INNER JOIN [dbo].[MessageReply] b WITH(NOLOCK)  ON a.IdMessageReply = b.Id
	INNER JOIN [dbo].[Message] c WITH(NOLOCK) ON b.IdMessage = c.Id
  WHERE c.[Date] < @LimitDate
  GROUP BY a.[Id],a.[IdMessageReply],a.[IdUser]
  ORDER BY a.[Id] ASC
END
