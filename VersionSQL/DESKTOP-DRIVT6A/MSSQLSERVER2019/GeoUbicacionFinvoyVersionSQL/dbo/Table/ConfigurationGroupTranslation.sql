/****** Object:  Table [dbo].[ConfigurationGroupTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ConfigurationGroupTranslation](
	[IdConfigurationGroup] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](2048) NULL,
 CONSTRAINT [PK_ConfigurationGroupTranslation] PRIMARY KEY CLUSTERED 
(
	[IdConfigurationGroup] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ConfigurationGroupTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ConfigurationGroupTranslation_ConfigurationGroup] FOREIGN KEY([IdConfigurationGroup])
REFERENCES [dbo].[ConfigurationGroup] ([Id])
ALTER TABLE [dbo].[ConfigurationGroupTranslation] CHECK CONSTRAINT [FK_ConfigurationGroupTranslation_ConfigurationGroup]
ALTER TABLE [dbo].[ConfigurationGroupTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ConfigurationGroupTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[ConfigurationGroupTranslation] CHECK CONSTRAINT [FK_ConfigurationGroupTranslation_Language]
