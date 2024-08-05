/****** Object:  Table [dbo].[FormReportFormatElementTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[FormReportFormatElementTranslation](
	[IdFormReportFormatElement] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_FormReportFormatElementTranslation] PRIMARY KEY CLUSTERED 
(
	[IdFormReportFormatElement] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FormReportFormatElementTranslation]  WITH CHECK ADD  CONSTRAINT [FK_FormReportFormatElementTranslation_FormReportFormatElement] FOREIGN KEY([IdFormReportFormatElement])
REFERENCES [dbo].[FormReportFormatElement] ([Id])
ALTER TABLE [dbo].[FormReportFormatElementTranslation] CHECK CONSTRAINT [FK_FormReportFormatElementTranslation_FormReportFormatElement]
ALTER TABLE [dbo].[FormReportFormatElementTranslation]  WITH CHECK ADD  CONSTRAINT [FK_FormReportFormatElementTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[FormReportFormatElementTranslation] CHECK CONSTRAINT [FK_FormReportFormatElementTranslation_Language]
