/****** Object:  Procedure [dbo].[SaveMobileExceptionLogs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 17/05/2016
-- Description:	SP para guardar un set de excepciones producidas desde la app mobile
-- =============================================
CREATE PROCEDURE [dbo].[SaveMobileExceptionLogs]
(
	@MobileExceptionLogs MobileExceptionLogTableType READONLY
)
AS
BEGIN
	INSERT INTO [dbo].[MobileExceptionLog]([Date], [IdPersonOfInterest], [ClassName], [MethodName], [ExceptionClassName], [ExceptionMessage], [ExceptionStackTrace], [ApplicationVersionCode], [ApplicationVersionName], [DeviceAvailableMemory], [DeviceTotalMemory], [DeviceModel], [DeviceSdkInt], [DeviceSdkName], [DeviceReleaseVersion])
	SELECT	[Date], [IdPersonOfInterest], [ClassName], [MethodName], [ExceptionClassName], [ExceptionMessage], [ExceptionStackTrace], [ApplicationVersionCode], [ApplicationVersionName], [DeviceAvailableMemory], [DeviceTotalMemory], [DeviceModel], [DeviceSdkInt], [DeviceSdkName], [DeviceReleaseVersion]
	FROM	@MobileExceptionLogs
END
