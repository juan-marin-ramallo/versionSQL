/****** Object:  Table [dbo].[ScheduleReportDayOfWeek]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleReportDayOfWeek](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdScheduleReport] [int] NOT NULL,
	[DayOfWeek] [int] NOT NULL,
 CONSTRAINT [PK_ScheduleReportDayOfWeek] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleReportDayOfWeek]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportDayOfWeek_ScheduleReport] FOREIGN KEY([IdScheduleReport])
REFERENCES [dbo].[ScheduleReport] ([Id])
ALTER TABLE [dbo].[ScheduleReportDayOfWeek] CHECK CONSTRAINT [FK_ScheduleReportDayOfWeek_ScheduleReport]
