/****** Object:  Table [dbo].[NotificationEmailLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[NotificationEmailLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CodeNotification] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Sent] [bit] NOT NULL,
	[Email] [varchar](255) NOT NULL,
	[IdUser] [int] NULL,
	[IdPersonOfInterest] [int] NULL,
	[TriesCount] [int] NULL,
 CONSTRAINT [PK_NotificationEmailLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[NotificationEmailLog]  WITH CHECK ADD  CONSTRAINT [FK_NotificationEmailLog_Notification] FOREIGN KEY([CodeNotification])
REFERENCES [dbo].[Notification] ([Code])
ALTER TABLE [dbo].[NotificationEmailLog] CHECK CONSTRAINT [FK_NotificationEmailLog_Notification]
ALTER TABLE [dbo].[NotificationEmailLog]  WITH CHECK ADD  CONSTRAINT [FK_NotificationEmailLog_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[NotificationEmailLog] CHECK CONSTRAINT [FK_NotificationEmailLog_PersonOfInterest]
ALTER TABLE [dbo].[NotificationEmailLog]  WITH CHECK ADD  CONSTRAINT [FK_NotificationEmailLog_Team] FOREIGN KEY([IdUser])
REFERENCES [dbo].[Team] ([Id])
ALTER TABLE [dbo].[NotificationEmailLog] CHECK CONSTRAINT [FK_NotificationEmailLog_Team]
