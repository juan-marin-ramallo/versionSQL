/****** Object:  Procedure [dbo].[SaveMobileExceptionLog]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 03/12/2013
-- Description:	SP para guardar una excepción producida desde la app mobile
-- =============================================
CREATE PROCEDURE [dbo].[SaveMobileExceptionLog]
(
	 @IdPersonOfInterest [sys].[int]
	,@Date [sys].[datetime]
	,@ClassName [sys].[varchar](100)
	,@MethodName [sys].[varchar](200)
	,@ExceptionClassName [sys].[varchar](100)
	,@ExceptionMessage [sys].[varchar](500) = NULL
	,@ExceptionStackTrace [sys].[varchar](8000) = NULL
	,@ApplicationVersionCode [sys].[smallint] = NULL
	,@ApplicationVersionName [sys].[varchar](50) = NULL
	,@DeviceAvailableMemory [sys].[bigint] = NULL
	,@DeviceTotalMemory [sys].[bigint] = NULL
	,@DeviceModel [sys].[varchar](100) = NULL
	,@DeviceSdkInt [sys].[smallint] = NULL
	,@DeviceSdkName [sys].[varchar](50) = NULL
	,@DeviceReleaseVersion [sys].[varchar](20) = NULL
)
AS
BEGIN
	INSERT INTO [dbo].[MobileExceptionLog]([Date], [IdPersonOfInterest], [ClassName], [MethodName], [ExceptionClassName], [ExceptionMessage], [ExceptionStackTrace], [ApplicationVersionCode], [ApplicationVersionName], [DeviceAvailableMemory], [DeviceTotalMemory], [DeviceModel], [DeviceSdkInt], [DeviceSdkName], [DeviceReleaseVersion])
	VALUES (@Date, @IdPersonOfInterest, @ClassName, @MethodName, @ExceptionClassName, @ExceptionMessage, @ExceptionStackTrace, @ApplicationVersionCode, @ApplicationVersionName, @DeviceAvailableMemory, @DeviceTotalMemory, @DeviceModel, @DeviceSdkInt, @DeviceSdkName, @DeviceReleaseVersion)
END
