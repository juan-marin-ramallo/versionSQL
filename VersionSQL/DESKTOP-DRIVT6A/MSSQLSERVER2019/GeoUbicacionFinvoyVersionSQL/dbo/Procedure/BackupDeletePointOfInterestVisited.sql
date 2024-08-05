/****** Object:  Procedure [dbo].[BackupDeletePointOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupDeletePointOfInterestVisited]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  DELETE a
  FROM [dbo].PointOfInterestVisited a WITH(NOLOCK)
  WHERE a.[LocationInDate] < @LimitDate
END
