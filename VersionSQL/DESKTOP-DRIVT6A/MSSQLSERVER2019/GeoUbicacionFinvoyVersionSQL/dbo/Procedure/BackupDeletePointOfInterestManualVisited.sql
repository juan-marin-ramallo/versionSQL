/****** Object:  Procedure [dbo].[BackupDeletePointOfInterestManualVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupDeletePointOfInterestManualVisited]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  DELETE a
  FROM [dbo].PointOfInterestManualVisited a WITH(NOLOCK)
  WHERE a.[ReceivedDate] < @LimitDate
END
