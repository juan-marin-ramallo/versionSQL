/****** Object:  Table [dbo].[ScheduleReportPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleReportPersonOfInterest](
	[IdScheduleReport] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
 CONSTRAINT [PK_ScheduleReportPersonOfInterest] PRIMARY KEY CLUSTERED 
(
	[IdScheduleReport] ASC,
	[IdPersonOfInterest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleReportPersonOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportPersonOfInterest_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[ScheduleReportPersonOfInterest] CHECK CONSTRAINT [FK_ScheduleReportPersonOfInterest_PersonOfInterest]
ALTER TABLE [dbo].[ScheduleReportPersonOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportPersonOfInterest_ScheduleReport] FOREIGN KEY([IdScheduleReport])
REFERENCES [dbo].[ScheduleReport] ([Id])
ALTER TABLE [dbo].[ScheduleReportPersonOfInterest] CHECK CONSTRAINT [FK_ScheduleReportPersonOfInterest_ScheduleReport]
