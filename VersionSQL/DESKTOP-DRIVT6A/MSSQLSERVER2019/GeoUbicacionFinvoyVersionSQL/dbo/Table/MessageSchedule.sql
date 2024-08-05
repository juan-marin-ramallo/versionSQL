/****** Object:  Table [dbo].[MessageSchedule]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MessageSchedule](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdMessage] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[SentDate] [datetime] NULL,
 CONSTRAINT [PK_MessageSchedule] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Message_PersonOfInterest] ON [dbo].[MessageSchedule]
(
	[IdMessage] ASC
)
INCLUDE([IdPersonOfInterest]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[MessageSchedule]  WITH CHECK ADD  CONSTRAINT [FK_MessageSchedule_Message] FOREIGN KEY([IdMessage])
REFERENCES [dbo].[Message] ([Id])
ALTER TABLE [dbo].[MessageSchedule] CHECK CONSTRAINT [FK_MessageSchedule_Message]
ALTER TABLE [dbo].[MessageSchedule]  WITH CHECK ADD  CONSTRAINT [FK_MessageSchedule_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[MessageSchedule] CHECK CONSTRAINT [FK_MessageSchedule_PersonOfInterest]
