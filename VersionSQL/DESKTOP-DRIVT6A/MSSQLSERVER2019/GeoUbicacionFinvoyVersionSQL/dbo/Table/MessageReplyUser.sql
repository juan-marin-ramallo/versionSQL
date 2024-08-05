/****** Object:  Table [dbo].[MessageReplyUser]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MessageReplyUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdMessageReply] [int] NOT NULL,
	[IdUser] [int] NOT NULL,
 CONSTRAINT [PK_MessageReplayUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MessageReplyUser]  WITH CHECK ADD  CONSTRAINT [FK_MessageReplayUser_MessageReply] FOREIGN KEY([IdMessageReply])
REFERENCES [dbo].[MessageReply] ([Id])
ALTER TABLE [dbo].[MessageReplyUser] CHECK CONSTRAINT [FK_MessageReplayUser_MessageReply]
ALTER TABLE [dbo].[MessageReplyUser]  WITH CHECK ADD  CONSTRAINT [FK_MessageReplayUser_Team] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[MessageReplyUser] CHECK CONSTRAINT [FK_MessageReplayUser_Team]
