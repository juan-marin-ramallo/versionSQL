/****** Object:  Table [dbo].[MobileExceptionLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MobileExceptionLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[ClassName] [varchar](100) NOT NULL,
	[MethodName] [varchar](200) NOT NULL,
	[ExceptionClassName] [varchar](100) NOT NULL,
	[ExceptionMessage] [varchar](500) NULL,
	[ExceptionStackTrace] [varchar](8000) NULL,
	[ApplicationVersionCode] [smallint] NULL,
	[ApplicationVersionName] [varchar](50) NULL,
	[DeviceAvailableMemory] [bigint] NULL,
	[DeviceTotalMemory] [bigint] NULL,
	[DeviceModel] [varchar](100) NULL,
	[DeviceSdkInt] [smallint] NULL,
	[DeviceSdkName] [varchar](50) NULL,
	[DeviceReleaseVersion] [varchar](20) NULL,
 CONSTRAINT [PK_MobileExceptionLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
