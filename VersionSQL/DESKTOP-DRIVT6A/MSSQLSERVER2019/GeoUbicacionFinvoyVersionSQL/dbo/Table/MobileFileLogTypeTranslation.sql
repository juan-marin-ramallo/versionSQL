/****** Object:  Table [dbo].[MobileFileLogTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MobileFileLogTypeTranslation](
	[IdMobileFileLogType] [smallint] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](20) NOT NULL,
 CONSTRAINT [PK_MobileFileLogTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[IdMobileFileLogType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MobileFileLogTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_MobileFileLogTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[MobileFileLogTypeTranslation] CHECK CONSTRAINT [FK_MobileFileLogTypeTranslation_Language]
ALTER TABLE [dbo].[MobileFileLogTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_MobileFileLogTypeTranslation_MobileFileLogType] FOREIGN KEY([IdMobileFileLogType])
REFERENCES [dbo].[MobileFileLogType] ([Id])
ALTER TABLE [dbo].[MobileFileLogTypeTranslation] CHECK CONSTRAINT [FK_MobileFileLogTypeTranslation_MobileFileLogType]
