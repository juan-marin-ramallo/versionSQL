/****** Object:  Procedure [dbo].[BackupGetMessage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetMessage]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[Date],a.[Importance],a.[Subject],a.[Message],a.[IdUser],a.[TheoricalSentDate],a.[ModifiedDate],a.[Deleted],a.[AllowReply]
  FROM [dbo].Message a WITH(NOLOCK)
  WHERE a.[Date] < @LimitDate
  GROUP BY a.[Id],a.[Date],a.[Importance],a.[Subject],a.[Message],a.[IdUser],a.[TheoricalSentDate],a.[ModifiedDate],a.[Deleted],a.[AllowReply]
  ORDER BY a.[Id] ASC
END
