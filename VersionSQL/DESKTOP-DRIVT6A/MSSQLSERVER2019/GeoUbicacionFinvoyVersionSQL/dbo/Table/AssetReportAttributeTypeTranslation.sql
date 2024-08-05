/****** Object:  Table [dbo].[AssetReportAttributeTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssetReportAttributeTypeTranslation](
	[IdAssetReportAttributeType] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_AssetReportAttributeTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[IdAssetReportAttributeType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AssetReportAttributeTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_AssetReportAttributeTypeTranslation_AssetReportAttributeType] FOREIGN KEY([IdAssetReportAttributeType])
REFERENCES [dbo].[AssetReportAttributeType] ([Id])
ALTER TABLE [dbo].[AssetReportAttributeTypeTranslation] CHECK CONSTRAINT [FK_AssetReportAttributeTypeTranslation_AssetReportAttributeType]
ALTER TABLE [dbo].[AssetReportAttributeTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_AssetReportAttributeTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[AssetReportAttributeTypeTranslation] CHECK CONSTRAINT [FK_AssetReportAttributeTypeTranslation_Language]
