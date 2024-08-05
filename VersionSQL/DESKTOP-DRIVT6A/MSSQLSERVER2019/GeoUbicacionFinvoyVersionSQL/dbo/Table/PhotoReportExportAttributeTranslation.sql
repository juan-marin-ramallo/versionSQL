/****** Object:  Table [dbo].[PhotoReportExportAttributeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PhotoReportExportAttributeTranslation](
	[IdPhotoReportExportAttribute] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](200) NOT NULL,
 CONSTRAINT [PK_PhotoReportExportAttributeTranslation] PRIMARY KEY CLUSTERED 
(
	[IdPhotoReportExportAttribute] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PhotoReportExportAttributeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PhotoReportExportAttributeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[PhotoReportExportAttributeTranslation] CHECK CONSTRAINT [FK_PhotoReportExportAttributeTranslation_Language]
ALTER TABLE [dbo].[PhotoReportExportAttributeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PhotoReportExportAttributeTranslation_PhotoReportExportAttribute] FOREIGN KEY([IdPhotoReportExportAttribute])
REFERENCES [dbo].[PhotoReportExportAttribute] ([Id])
ALTER TABLE [dbo].[PhotoReportExportAttributeTranslation] CHECK CONSTRAINT [FK_PhotoReportExportAttributeTranslation_PhotoReportExportAttribute]
