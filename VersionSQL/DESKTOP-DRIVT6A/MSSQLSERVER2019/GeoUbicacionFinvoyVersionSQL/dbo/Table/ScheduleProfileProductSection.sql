/****** Object:  Table [dbo].[ScheduleProfileProductSection]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleProfileProductSection](
	[IdScheduleProfile] [int] NOT NULL,
	[IdProductReportSection] [int] NOT NULL,
 CONSTRAINT [PK_ScheduleProfileProductSection] PRIMARY KEY CLUSTERED 
(
	[IdScheduleProfile] ASC,
	[IdProductReportSection] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleProfileProductSection]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfileProductSection_ProductReportSection] FOREIGN KEY([IdProductReportSection])
REFERENCES [dbo].[ProductReportSection] ([Id])
ALTER TABLE [dbo].[ScheduleProfileProductSection] CHECK CONSTRAINT [FK_ScheduleProfileProductSection_ProductReportSection]
ALTER TABLE [dbo].[ScheduleProfileProductSection]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfileProductSection_ScheduleProfile] FOREIGN KEY([IdScheduleProfile])
REFERENCES [dbo].[ScheduleProfile] ([Id])
ALTER TABLE [dbo].[ScheduleProfileProductSection] CHECK CONSTRAINT [FK_ScheduleProfileProductSection_ScheduleProfile]
