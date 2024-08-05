/****** Object:  Table [dbo].[NotificationTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[NotificationTranslation](
	[CodeNotification] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Subject] [varchar](100) NOT NULL,
	[Description] [varchar](500) NOT NULL,
	[Body] [varchar](5000) NULL,
 CONSTRAINT [PK_NotificationTranslation] PRIMARY KEY CLUSTERED 
(
	[CodeNotification] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[NotificationTranslation]  WITH CHECK ADD  CONSTRAINT [FK_NotificationTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[NotificationTranslation] CHECK CONSTRAINT [FK_NotificationTranslation_Language]
ALTER TABLE [dbo].[NotificationTranslation]  WITH CHECK ADD  CONSTRAINT [FK_NotificationTranslation_Notification] FOREIGN KEY([CodeNotification])
REFERENCES [dbo].[Notification] ([Code])
ALTER TABLE [dbo].[NotificationTranslation] CHECK CONSTRAINT [FK_NotificationTranslation_Notification]
