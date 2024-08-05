/****** Object:  Table [dbo].[PackageConfigurationTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PackageConfigurationTranslation](
	[IdPackageConfiguration] [smallint] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[ErrorMessage] [varchar](200) NOT NULL,
 CONSTRAINT [PK_PackageConfigurationTranslation] PRIMARY KEY CLUSTERED 
(
	[IdPackageConfiguration] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PackageConfigurationTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PackageConfigurationTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[PackageConfigurationTranslation] CHECK CONSTRAINT [FK_PackageConfigurationTranslation_Language]
ALTER TABLE [dbo].[PackageConfigurationTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PackageConfigurationTranslation_PackageConfiguration] FOREIGN KEY([IdPackageConfiguration])
REFERENCES [dbo].[PackageConfiguration] ([Id])
ALTER TABLE [dbo].[PackageConfigurationTranslation] CHECK CONSTRAINT [FK_PackageConfigurationTranslation_PackageConfiguration]
