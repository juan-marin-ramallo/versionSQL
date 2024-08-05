/****** Object:  Procedure [dbo].[BackupGetAuditLog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetAuditLog]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[IdUser],a.[Date],a.[Entity],a.[Action],a.[ControllerName],a.[ActionName],a.[ResultData]
  FROM [dbo].AuditLog a WITH(NOLOCK)
  WHERE a.[Date] < @LimitDate
  GROUP BY a.[Id],a.[IdUser],a.[Date],a.[Entity],a.[Action],a.[ControllerName],a.[ActionName],a.[ResultData]
  ORDER BY a.[Id] ASC
END
