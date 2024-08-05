/****** Object:  Procedure [dbo].[BackupGetLocation]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetLocation]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[IdPersonOfInterest],a.[ReceivedDate],a.[Date],a.[Latitude],a.[Longitude],a.[Accuracy],a.[Processed],a.[BatteryLevel]
  FROM [dbo].[Location] a WITH(NOLOCK)
  WHERE a.[Date] < @LimitDate
  GROUP BY a.[Id],a.[IdPersonOfInterest],a.[ReceivedDate],a.[Date],a.[Latitude],a.[Longitude],a.[Accuracy],a.[Processed],a.[BatteryLevel]
  ORDER BY a.[Id] ASC
END
