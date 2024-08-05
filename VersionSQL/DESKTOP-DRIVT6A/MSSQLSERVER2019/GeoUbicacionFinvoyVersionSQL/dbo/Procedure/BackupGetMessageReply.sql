/****** Object:  Procedure [dbo].[BackupGetMessageReply]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetMessageReply]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[Message],a.[IdPersonOfInterest],a.[IdMessage],a.[Date],a.[ReceivedDate]
  FROM [dbo].MessageReply a WITH(NOLOCK)
	INNER JOIN [dbo].[Message] b WITH(NOLOCK) ON a.IdMessage = b.Id
  WHERE b.[Date] < @LimitDate
  GROUP BY a.[Id],a.[Message],a.[IdPersonOfInterest],a.[IdMessage],a.[Date],a.[ReceivedDate]
  ORDER BY a.[Id] ASC
END
