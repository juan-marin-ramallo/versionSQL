/****** Object:  Procedure [dbo].[BackupDeleteProductReportAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupDeleteProductReportAttributeValue]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  DELETE a
  FROM [dbo].ProductReportAttributeValue a WITH(NOLOCK)
	INNER JOIN dbo.ProductReportDynamic b WITH(NOLOCK) ON a.IdProductReport = b.Id
  WHERE b.[ReportDateTime] < @LimitDate
END
