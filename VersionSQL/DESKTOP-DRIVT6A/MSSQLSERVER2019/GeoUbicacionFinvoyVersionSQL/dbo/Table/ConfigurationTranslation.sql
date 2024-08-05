/****** Object:  Table [dbo].[ConfigurationTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ConfigurationTranslation](
	[IdConfiguration] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](500) NOT NULL,
	[HelpMessage] [varchar](2048) NULL,
 CONSTRAINT [PK_ConfigurationTranslation] PRIMARY KEY CLUSTERED 
(
	[IdConfiguration] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ConfigurationTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ConfigurationTranslation_Configuration] FOREIGN KEY([IdConfiguration])
REFERENCES [dbo].[Configuration] ([Id])
ALTER TABLE [dbo].[ConfigurationTranslation] CHECK CONSTRAINT [FK_ConfigurationTranslation_Configuration]
ALTER TABLE [dbo].[ConfigurationTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ConfigurationTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[ConfigurationTranslation] CHECK CONSTRAINT [FK_ConfigurationTranslation_Language]
