/****** Object:  Procedure [dbo].[BackupDeleteMessageReply]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupDeleteMessageReply]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  DELETE a
  FROM [dbo].MessageReply a WITH(NOLOCK)
	INNER JOIN [dbo].[Message] b WITH(NOLOCK) ON a.IdMessage = b.Id
  WHERE b.[Date] < @LimitDate
END
