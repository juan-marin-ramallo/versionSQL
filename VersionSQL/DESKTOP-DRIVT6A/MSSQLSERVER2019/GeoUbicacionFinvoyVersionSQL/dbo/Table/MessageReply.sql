/****** Object:  Table [dbo].[MessageReply]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MessageReply](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Message] [varchar](1000) NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdMessage] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[ReceivedDate] [datetime] NULL,
 CONSTRAINT [PK_MessageReply] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MessageReply]  WITH CHECK ADD  CONSTRAINT [FK_MessageReply_Message] FOREIGN KEY([IdMessage])
REFERENCES [dbo].[Message] ([Id])
ALTER TABLE [dbo].[MessageReply] CHECK CONSTRAINT [FK_MessageReply_Message]
ALTER TABLE [dbo].[MessageReply]  WITH CHECK ADD  CONSTRAINT [FK_MessageReply_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[MessageReply] CHECK CONSTRAINT [FK_MessageReply_PersonOfInterest]
