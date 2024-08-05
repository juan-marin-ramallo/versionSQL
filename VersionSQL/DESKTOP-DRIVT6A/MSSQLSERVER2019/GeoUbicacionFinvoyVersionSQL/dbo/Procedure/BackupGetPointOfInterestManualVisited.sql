/****** Object:  Procedure [dbo].[BackupGetPointOfInterestManualVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetPointOfInterestManualVisited]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[IdPersonOfInterest],a.[IdPointOfInterest],a.[CheckInDate],a.[CheckOutDate],a.[ElapsedTime],a.[ReceivedDate],a.[DeletedByNotVisited],a.[Edited]
  FROM [dbo].PointOfInterestManualVisited a WITH(NOLOCK)
  WHERE a.[ReceivedDate] < @LimitDate
  GROUP BY a.[Id],a.[IdPersonOfInterest],a.[IdPointOfInterest],a.[CheckInDate],a.[CheckOutDate],a.[ElapsedTime],a.[ReceivedDate],a.[DeletedByNotVisited],a.[Edited]
  ORDER BY a.[Id] ASC
END
