/****** Object:  Procedure [dbo].[BackupDeleteMessageSchedule]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupDeleteMessageSchedule]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  DELETE a
  FROM [dbo].MessageSchedule a WITH(NOLOCK)
	INNER JOIN [dbo].[Message] b WITH(NOLOCK) ON a.IdMessage = b.Id
  WHERE b.[Date] < @LimitDate
END
