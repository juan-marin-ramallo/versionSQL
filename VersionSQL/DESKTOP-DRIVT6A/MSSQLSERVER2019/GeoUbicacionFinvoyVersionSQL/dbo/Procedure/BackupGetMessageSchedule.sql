/****** Object:  Procedure [dbo].[BackupGetMessageSchedule]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetMessageSchedule]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.Id, a.IdMessage, a.IdPersonOfInterest, a.SentDate
  FROM [dbo].MessageSchedule a WITH(NOLOCK)
	INNER JOIN [dbo].[Message] b WITH(NOLOCK) ON a.IdMessage = b.Id
  WHERE b.[Date] < @LimitDate
  GROUP BY  a.Id, a.IdMessage, a.IdPersonOfInterest, a.SentDate
  ORDER BY a.Id ASC
END
