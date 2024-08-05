/****** Object:  Table [dbo].[MarkLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MarkLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdUser] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Comment] [varchar](1024) NOT NULL,
	[IdEntry] [int] NOT NULL,
	[EntryDateOld] [datetime] NULL,
	[EntryDate] [datetime] NULL,
	[IdExit] [int] NULL,
	[ExitDateOld] [datetime] NULL,
	[ExitDate] [datetime] NULL,
	[RestEndDate] [datetime] NULL,
	[IdRestStart] [int] NULL,
	[IdRestEnd] [int] NULL,
	[RestStartDateOld] [datetime] NULL,
	[RestEndDateOld] [datetime] NULL,
	[RestStartDate] [datetime] NULL,
 CONSTRAINT [PK_MarkLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MarkLog]  WITH CHECK ADD  CONSTRAINT [FK_MarkLog_MarkEntry] FOREIGN KEY([IdEntry])
REFERENCES [dbo].[Mark] ([Id])
ALTER TABLE [dbo].[MarkLog] CHECK CONSTRAINT [FK_MarkLog_MarkEntry]
ALTER TABLE [dbo].[MarkLog]  WITH CHECK ADD  CONSTRAINT [FK_MarkLog_MarkExit] FOREIGN KEY([IdExit])
REFERENCES [dbo].[Mark] ([Id])
ALTER TABLE [dbo].[MarkLog] CHECK CONSTRAINT [FK_MarkLog_MarkExit]
ALTER TABLE [dbo].[MarkLog]  WITH CHECK ADD  CONSTRAINT [FK_MarkLog_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[MarkLog] CHECK CONSTRAINT [FK_MarkLog_User]
