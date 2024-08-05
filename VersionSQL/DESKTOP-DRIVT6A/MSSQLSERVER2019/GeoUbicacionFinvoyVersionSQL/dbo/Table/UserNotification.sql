/****** Object:  Table [dbo].[UserNotification]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[UserNotification](
	[IdUser] [int] NOT NULL,
	[CodeNotification] [int] NOT NULL,
 CONSTRAINT [PK_UserNotification] PRIMARY KEY CLUSTERED 
(
	[IdUser] ASC,
	[CodeNotification] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UserNotification]  WITH CHECK ADD  CONSTRAINT [FK_UserNotification_Notification] FOREIGN KEY([CodeNotification])
REFERENCES [dbo].[Notification] ([Code])
ALTER TABLE [dbo].[UserNotification] CHECK CONSTRAINT [FK_UserNotification_Notification]
ALTER TABLE [dbo].[UserNotification]  WITH CHECK ADD  CONSTRAINT [FK_UserNotification_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[UserNotification] CHECK CONSTRAINT [FK_UserNotification_User]
