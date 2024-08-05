/****** Object:  Table [dbo].[CustomReportTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomReportTypeTranslation](
	[IdCustomReportType] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_CustomReportTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[IdCustomReportType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomReportTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_CustomReportTypeTranslation_CustomReportType] FOREIGN KEY([IdCustomReportType])
REFERENCES [dbo].[CustomReportType] ([Id])
ALTER TABLE [dbo].[CustomReportTypeTranslation] CHECK CONSTRAINT [FK_CustomReportTypeTranslation_CustomReportType]
ALTER TABLE [dbo].[CustomReportTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_CustomReportTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[CustomReportTypeTranslation] CHECK CONSTRAINT [FK_CustomReportTypeTranslation_Language]
