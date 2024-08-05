/****** Object:  Table [dbo].[PowerPointMarkupPhotoReportElement]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PowerPointMarkupPhotoReportElement](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPowerPointMarkupPhotoReport] [int] NOT NULL,
	[IdPowerPointMarkupElement] [int] NOT NULL,
	[IdPhotoReportExportAttribute] [int] NOT NULL,
	[PageIndex] [int] NOT NULL,
 CONSTRAINT [PK_PowerPointMarkupPhotoReportElement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PowerPointMarkupPhotoReportElement]  WITH CHECK ADD  CONSTRAINT [FK_PowerPointMarkupPhotoReportElement_PhotoReportExportAttribute] FOREIGN KEY([IdPhotoReportExportAttribute])
REFERENCES [dbo].[PhotoReportExportAttribute] ([Id])
ALTER TABLE [dbo].[PowerPointMarkupPhotoReportElement] CHECK CONSTRAINT [FK_PowerPointMarkupPhotoReportElement_PhotoReportExportAttribute]
ALTER TABLE [dbo].[PowerPointMarkupPhotoReportElement]  WITH CHECK ADD  CONSTRAINT [FK_PowerPointMarkupPhotoReportElement_PowerpointMarkupElement] FOREIGN KEY([IdPowerPointMarkupElement])
REFERENCES [dbo].[PowerpointMarkupElement] ([Id])
ALTER TABLE [dbo].[PowerPointMarkupPhotoReportElement] CHECK CONSTRAINT [FK_PowerPointMarkupPhotoReportElement_PowerpointMarkupElement]
ALTER TABLE [dbo].[PowerPointMarkupPhotoReportElement]  WITH CHECK ADD  CONSTRAINT [FK_PowerPointMarkupPhotoReportElement_PowerPointMarkupPhotoReport] FOREIGN KEY([IdPowerPointMarkupPhotoReport])
REFERENCES [dbo].[PowerPointMarkupPhotoReport] ([Id])
ALTER TABLE [dbo].[PowerPointMarkupPhotoReportElement] CHECK CONSTRAINT [FK_PowerPointMarkupPhotoReportElement_PowerPointMarkupPhotoReport]
