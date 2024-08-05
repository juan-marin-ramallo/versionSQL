/****** Object:  Table [dbo].[Message]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Message](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Importance] [smallint] NOT NULL,
	[Subject] [varchar](100) NOT NULL,
	[Message] [varchar](8000) NOT NULL,
	[IdUser] [int] NOT NULL,
	[TheoricalSentDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Deleted] [bit] NULL,
	[AllowReply] [bit] NULL,
 CONSTRAINT [PK_Message] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Message]  WITH NOCHECK ADD  CONSTRAINT [FK_Message_MessageImportance] FOREIGN KEY([Importance])
REFERENCES [dbo].[MessageImportance] ([Id])
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_MessageImportance]
ALTER TABLE [dbo].[Message]  WITH NOCHECK ADD  CONSTRAINT [FK_Message_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_User]
