/****** Object:  Table [dbo].[MessagePersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MessagePersonOfInterest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdMessage] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[Received] [bit] NOT NULL,
	[ReceivedDate] [datetime] NULL,
	[Read] [bit] NOT NULL,
	[ReadDate] [datetime] NULL,
 CONSTRAINT [PK_MessageStocker_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NCL_IX_MessagePersonOfInterest_IdMessage_IdPersonOfInterest_Received] ON [dbo].[MessagePersonOfInterest]
(
	[IdMessage] ASC,
	[IdPersonOfInterest] ASC,
	[Received] ASC
)
INCLUDE([Id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [PK_MessagePersonOfInterest] ON [dbo].[MessagePersonOfInterest]
(
	[IdPersonOfInterest] ASC
)
INCLUDE([IdMessage]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[MessagePersonOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_MessagePersonOfInterest_Message] FOREIGN KEY([IdMessage])
REFERENCES [dbo].[Message] ([Id])
ALTER TABLE [dbo].[MessagePersonOfInterest] CHECK CONSTRAINT [FK_MessagePersonOfInterest_Message]
ALTER TABLE [dbo].[MessagePersonOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_MessagePersonOfInterest_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[MessagePersonOfInterest] CHECK CONSTRAINT [FK_MessagePersonOfInterest_PersonOfInterest]
