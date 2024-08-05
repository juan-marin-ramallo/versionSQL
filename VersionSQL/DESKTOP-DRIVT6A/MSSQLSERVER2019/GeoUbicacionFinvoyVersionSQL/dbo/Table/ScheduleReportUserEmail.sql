/****** Object:  Table [dbo].[ScheduleReportUserEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleReportUserEmail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdScheduleReport] [int] NULL,
	[Email] [varchar](100) NULL,
 CONSTRAINT [PK_ScheduleReportUserEmail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleReportUserEmail]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportUserEmail_ScheduleReport] FOREIGN KEY([IdScheduleReport])
REFERENCES [dbo].[ScheduleReport] ([Id])
ALTER TABLE [dbo].[ScheduleReportUserEmail] CHECK CONSTRAINT [FK_ScheduleReportUserEmail_ScheduleReport]
