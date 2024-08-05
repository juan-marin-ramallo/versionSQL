/****** Object:  Table [dbo].[ScheduleReportTypeFile]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleReportTypeFile](
	[IdScheduleReportType] [int] NOT NULL,
	[IdFileType] [int] NOT NULL,
 CONSTRAINT [PK_ScheduleReportTypeFile] PRIMARY KEY CLUSTERED 
(
	[IdScheduleReportType] ASC,
	[IdFileType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleReportTypeFile]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportTypeFile_AvailableFileType] FOREIGN KEY([IdFileType])
REFERENCES [dbo].[AvailableFileType] ([Id])
ALTER TABLE [dbo].[ScheduleReportTypeFile] CHECK CONSTRAINT [FK_ScheduleReportTypeFile_AvailableFileType]
ALTER TABLE [dbo].[ScheduleReportTypeFile]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportTypeFile_ScheduleReportType] FOREIGN KEY([IdScheduleReportType])
REFERENCES [dbo].[ScheduleReportType] ([Id])
ALTER TABLE [dbo].[ScheduleReportTypeFile] CHECK CONSTRAINT [FK_ScheduleReportTypeFile_ScheduleReportType]
