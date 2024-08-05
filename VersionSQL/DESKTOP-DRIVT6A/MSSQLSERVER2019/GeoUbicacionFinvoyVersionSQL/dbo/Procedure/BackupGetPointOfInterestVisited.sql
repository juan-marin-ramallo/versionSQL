/****** Object:  Procedure [dbo].[BackupGetPointOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetPointOfInterestVisited]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[IdPersonOfInterest],a.[IdLocationIn],a.[LocationInDate],a.[IdLocationOut],a.[LocationOutDate],a.[IdPointOfInterest],a.[ElapsedTime],a.[ClosedByChangeOfDay],a.[DeletedByNotVisited]
  FROM [dbo].PointOfInterestVisited a WITH(NOLOCK)
  WHERE a.[LocationOutDate] < @LimitDate
  GROUP BY a.[Id],a.[IdPersonOfInterest],a.[IdLocationIn],a.[LocationInDate],a.[IdLocationOut],a.[LocationOutDate],a.[IdPointOfInterest],a.[ElapsedTime],a.[ClosedByChangeOfDay],a.[DeletedByNotVisited]
  ORDER BY a.[Id] ASC
END
