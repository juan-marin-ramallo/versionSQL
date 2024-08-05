/****** Object:  Procedure [dbo].[BackupGetProductReportAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetProductReportAttributeValue]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[Value],a.[IdProductReport],a.[IdProductReportAttribute],a.[IdProductReportAttributeOption],a.[ImageName],a.[ImageEncoded],a.[ImageUrl]
  FROM [dbo].ProductReportAttributeValue a WITH(NOLOCK)
	INNER JOIN dbo.ProductReportDynamic b WITH(NOLOCK) ON a.IdProductReport = b.Id
  WHERE b.[ReportDateTime] < @LimitDate
  GROUP BY a.[Id],a.[Value],a.[IdProductReport],a.[IdProductReportAttribute],a.[IdProductReportAttributeOption],a.[ImageName],a.[ImageEncoded],a.[ImageUrl]
  ORDER BY a.[Id] ASC
END
