/****** Object:  Table [dbo].[SynchronizationLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[SynchronizationLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[SyncType] [int] NOT NULL,
	[SyncSaveType] [smallint] NOT NULL,
	[Errors] [bit] NOT NULL,
	[TotalCount] [int] NOT NULL,
	[SuccessCount] [int] NOT NULL,
	[ErrorCount] [int] NOT NULL,
	[Exception] [varchar](2048) NULL,
	[RequestBody] [varbinary](max) NULL,
 CONSTRAINT [PK_SynchronizationLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[SynchronizationLog] ADD  CONSTRAINT [DF_SynchronizationLog_SyncSaveType]  DEFAULT ((2)) FOR [SyncSaveType]
