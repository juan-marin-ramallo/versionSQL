/****** Object:  Table [dbo].[Meeting]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Meeting](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Subject] [nvarchar](50) NULL,
	[Start] [datetime] NOT NULL,
	[End] [datetime] NULL,
	[UserId] [int] NOT NULL,
	[ActualStart] [datetime] NULL,
	[ActualEnd] [datetime] NULL,
	[Minute] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[MicrosoftEventId] [varchar](2024) NULL,
	[MinuteSent] [bit] NOT NULL,
	[MinuteFileName] [varchar](100) NULL,
	[MinuteRealFileName] [varchar](100) NULL,
	[MinuteFileEncoded] [varbinary](max) NULL,
	[SignaturesFileName] [varchar](100) NULL,
	[SignaturesRealFileName] [varchar](100) NULL,
	[SignaturesFileEncoded] [varbinary](max) NULL,
	[Synced] [bit] NULL,
	[SyncType] [smallint] NULL,
	[IsFixed] [bit] NULL,
 CONSTRAINT [PK_Meeting] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Meeting] ADD  CONSTRAINT [DF_Meeting_MicrosoftEventId]  DEFAULT (NULL) FOR [MicrosoftEventId]
ALTER TABLE [dbo].[Meeting] ADD  CONSTRAINT [DF_Meeting_MinuteSent]  DEFAULT ((0)) FOR [MinuteSent]
