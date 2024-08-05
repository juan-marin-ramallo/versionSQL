/****** Object:  Procedure [dbo].[BackupDeleteCompletedForm]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupDeleteCompletedForm]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  DELETE a
  FROM [dbo].CompletedForm a WITH(NOLOCK)
  WHERE a.[Date] < @LimitDate
END
