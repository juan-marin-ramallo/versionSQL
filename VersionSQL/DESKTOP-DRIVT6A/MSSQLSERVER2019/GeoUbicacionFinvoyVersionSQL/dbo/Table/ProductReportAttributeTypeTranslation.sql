/****** Object:  Table [dbo].[ProductReportAttributeTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductReportAttributeTypeTranslation](
	[IdProductReportAttributeType] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ProductReportAttributeTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[IdProductReportAttributeType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductReportAttributeTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportAttributeTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[ProductReportAttributeTypeTranslation] CHECK CONSTRAINT [FK_ProductReportAttributeTypeTranslation_Language]
ALTER TABLE [dbo].[ProductReportAttributeTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportAttributeTypeTranslation_ProductReportAttributeType] FOREIGN KEY([IdProductReportAttributeType])
REFERENCES [dbo].[ProductReportAttributeType] ([Id])
ALTER TABLE [dbo].[ProductReportAttributeTypeTranslation] CHECK CONSTRAINT [FK_ProductReportAttributeTypeTranslation_ProductReportAttributeType]
