/****** Object:  Table [dbo].[AssetReportAttributeVisibilityTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssetReportAttributeVisibilityTypeTranslation](
	[IdAssetReportAttributeVisibilityType] [smallint] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_AssetReportAttributeVisibilityTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[IdAssetReportAttributeVisibilityType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AssetReportAttributeVisibilityTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_AssetReportAttributeVisibilityTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[AssetReportAttributeVisibilityTypeTranslation] CHECK CONSTRAINT [FK_AssetReportAttributeVisibilityTypeTranslation_Language]
