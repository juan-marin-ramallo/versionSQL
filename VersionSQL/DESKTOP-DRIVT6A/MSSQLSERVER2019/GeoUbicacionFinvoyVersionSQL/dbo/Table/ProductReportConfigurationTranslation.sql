/****** Object:  Table [dbo].[ProductReportConfigurationTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductReportConfigurationTranslation](
	[IdProductReportConfiguration] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ProductReportConfigurationTranslation] PRIMARY KEY CLUSTERED 
(
	[IdProductReportConfiguration] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductReportConfigurationTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportConfigurationTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[ProductReportConfigurationTranslation] CHECK CONSTRAINT [FK_ProductReportConfigurationTranslation_Language]
ALTER TABLE [dbo].[ProductReportConfigurationTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportConfigurationTranslation_ProductReportConfiguration] FOREIGN KEY([IdProductReportConfiguration])
REFERENCES [dbo].[ProductReportConfiguration] ([Id])
ALTER TABLE [dbo].[ProductReportConfigurationTranslation] CHECK CONSTRAINT [FK_ProductReportConfigurationTranslation_ProductReportConfiguration]
