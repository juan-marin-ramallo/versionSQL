/****** Object:  Procedure [dbo].[BackupGetMobileExceptionLog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetMobileExceptionLog]
(
  @LimitDate [sys].[DATETIME]
)
AS
BEGIN
  SELECT a.[Id],a.[Date],a.[IdPersonOfInterest],a.[ClassName],a.[MethodName],a.[ExceptionClassName],a.[ExceptionMessage],a.[ExceptionStackTrace],a.[ApplicationVersionCode],a.[ApplicationVersionName],a.[DeviceAvailableMemory],a.[DeviceTotalMemory],a.[DeviceModel],a.[DeviceSdkInt],a.[DeviceSdkName],a.[DeviceReleaseVersion]
  FROM [dbo].MobileExceptionLog a WITH(NOLOCK)
  WHERE a.[Date] < @LimitDate
  GROUP BY a.[Id],a.[Date],a.[IdPersonOfInterest],a.[ClassName],a.[MethodName],a.[ExceptionClassName],a.[ExceptionMessage],a.[ExceptionStackTrace],a.[ApplicationVersionCode],a.[ApplicationVersionName],a.[DeviceAvailableMemory],a.[DeviceTotalMemory],a.[DeviceModel],a.[DeviceSdkInt],a.[DeviceSdkName],a.[DeviceReleaseVersion]
  ORDER BY a.[Id] ASC
END
