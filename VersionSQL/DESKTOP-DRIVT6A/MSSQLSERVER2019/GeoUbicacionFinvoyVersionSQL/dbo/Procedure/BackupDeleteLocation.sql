/****** Object:  Procedure [dbo].[BackupDeleteLocation]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupDeleteLocation]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  DELETE a
  FROM [dbo].[Location] a WITH(NOLOCK)
  WHERE a.[Date] < @LimitDate
END
