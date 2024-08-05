/****** Object:  Procedure [dbo].[BackupDeleteRouteDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BackupDeleteRouteDetail]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  DELETE a
  FROM [dbo].RouteDetail a WITH(NOLOCK)
  WHERE a.[RouteDate] < @LimitDate
END
