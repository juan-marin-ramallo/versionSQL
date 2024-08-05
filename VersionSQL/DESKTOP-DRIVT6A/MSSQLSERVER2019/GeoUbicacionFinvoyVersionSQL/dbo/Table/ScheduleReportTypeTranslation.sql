/****** Object:  Table [dbo].[ScheduleReportTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleReportTypeTranslation](
	[IdScheduleReportType] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_ScheduleReportTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[IdScheduleReportType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleReportTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[ScheduleReportTypeTranslation] CHECK CONSTRAINT [FK_ScheduleReportTypeTranslation_Language]
ALTER TABLE [dbo].[ScheduleReportTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportTypeTranslation_ScheduleReportType] FOREIGN KEY([IdScheduleReportType])
REFERENCES [dbo].[ScheduleReportType] ([Id])
ALTER TABLE [dbo].[ScheduleReportTypeTranslation] CHECK CONSTRAINT [FK_ScheduleReportTypeTranslation_ScheduleReportType]
