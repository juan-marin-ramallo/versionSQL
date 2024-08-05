/****** Object:  Table [dbo].[FormReportFormatOptionsTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[FormReportFormatOptionsTranslation](
	[IdFormReportFormatOptions] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_FormReportFormatOptionsTranslation] PRIMARY KEY CLUSTERED 
(
	[IdFormReportFormatOptions] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FormReportFormatOptionsTranslation]  WITH CHECK ADD  CONSTRAINT [FK_FormReportFormatOptionsTranslation_FormReportFormatOptions] FOREIGN KEY([IdFormReportFormatOptions])
REFERENCES [dbo].[FormReportFormatOptions] ([Id])
ALTER TABLE [dbo].[FormReportFormatOptionsTranslation] CHECK CONSTRAINT [FK_FormReportFormatOptionsTranslation_FormReportFormatOptions]
ALTER TABLE [dbo].[FormReportFormatOptionsTranslation]  WITH CHECK ADD  CONSTRAINT [FK_FormReportFormatOptionsTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[FormReportFormatOptionsTranslation] CHECK CONSTRAINT [FK_FormReportFormatOptionsTranslation_Language]
