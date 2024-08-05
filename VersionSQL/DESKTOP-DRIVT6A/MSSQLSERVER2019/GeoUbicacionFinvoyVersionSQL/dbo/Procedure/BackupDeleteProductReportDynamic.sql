/****** Object:  Procedure [dbo].[BackupDeleteProductReportDynamic]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupDeleteProductReportDynamic]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  DELETE a
  FROM [dbo].ProductReportDynamic a WITH(NOLOCK)
  WHERE a.[ReportDateTime] < @LimitDate
END
