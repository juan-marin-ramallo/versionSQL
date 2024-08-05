/****** Object:  Table [dbo].[ScheduleReportUser]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleReportUser](
	[IdScheduleReport] [int] NOT NULL,
	[IdUser] [int] NOT NULL,
 CONSTRAINT [PK_ScheduleReportUser] PRIMARY KEY CLUSTERED 
(
	[IdScheduleReport] ASC,
	[IdUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleReportUser]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportUser_ScheduleReport] FOREIGN KEY([IdScheduleReport])
REFERENCES [dbo].[ScheduleReport] ([Id])
ALTER TABLE [dbo].[ScheduleReportUser] CHECK CONSTRAINT [FK_ScheduleReportUser_ScheduleReport]
ALTER TABLE [dbo].[ScheduleReportUser]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportUser_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[ScheduleReportUser] CHECK CONSTRAINT [FK_ScheduleReportUser_User]
