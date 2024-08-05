/****** Object:  Procedure [dbo].[BackupGetProductReportDynamic]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetProductReportDynamic]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[IdProduct],a.[IdPersonOfInterest],a.[IdPointOfInterest],a.[Deleted],a.[ReportDateTime],a.[ReportReceivedDate],a.[TheoricalStock],a.[TheoricalPrice],a.[Email]
  FROM [dbo].ProductReportDynamic a WITH(NOLOCK)
  WHERE a.[ReportDateTime] < @LimitDate
  GROUP BY a.[Id],a.[IdProduct],a.[IdPersonOfInterest],a.[IdPointOfInterest],a.[Deleted],a.[ReportDateTime],a.[ReportReceivedDate],a.[TheoricalStock],a.[TheoricalPrice],a.[Email]
  ORDER BY a.[Id] ASC
END
