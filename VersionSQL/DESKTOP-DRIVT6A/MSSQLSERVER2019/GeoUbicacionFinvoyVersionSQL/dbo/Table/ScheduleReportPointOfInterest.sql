/****** Object:  Table [dbo].[ScheduleReportPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleReportPointOfInterest](
	[IdScheduleReport] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
 CONSTRAINT [PK_ScheduleReportPointOfInterest] PRIMARY KEY CLUSTERED 
(
	[IdScheduleReport] ASC,
	[IdPointOfInterest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleReportPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportPointOfInterest_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[ScheduleReportPointOfInterest] CHECK CONSTRAINT [FK_ScheduleReportPointOfInterest_PointOfInterest]
ALTER TABLE [dbo].[ScheduleReportPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportPointOfInterest_ScheduleReport] FOREIGN KEY([IdScheduleReport])
REFERENCES [dbo].[ScheduleReport] ([Id])
ALTER TABLE [dbo].[ScheduleReportPointOfInterest] CHECK CONSTRAINT [FK_ScheduleReportPointOfInterest_ScheduleReport]
