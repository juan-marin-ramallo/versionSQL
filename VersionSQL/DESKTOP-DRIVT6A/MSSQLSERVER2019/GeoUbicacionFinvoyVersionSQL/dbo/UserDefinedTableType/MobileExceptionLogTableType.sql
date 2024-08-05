/****** Object:  UserDefinedTableType [dbo].[MobileExceptionLogTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[MobileExceptionLogTableType] AS TABLE(
	[Date] [datetime] NULL,
	[IdPersonOfInterest] [int] NULL,
	[ClassName] [varchar](100) NULL,
	[MethodName] [varchar](200) NULL,
	[ExceptionClassName] [varchar](100) NULL,
	[ExceptionMessage] [varchar](500) NULL,
	[ExceptionStackTrace] [varchar](8000) NULL,
	[ApplicationVersionCode] [smallint] NULL,
	[ApplicationVersionName] [varchar](50) NULL,
	[DeviceAvailableMemory] [bigint] NULL,
	[DeviceTotalMemory] [bigint] NULL,
	[DeviceModel] [varchar](100) NULL,
	[DeviceSdkInt] [smallint] NULL,
	[DeviceSdkName] [varchar](50) NULL,
	[DeviceReleaseVersion] [varchar](20) NULL
)
