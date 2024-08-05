/****** Object:  Table [dbo].[ScheduleReportType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleReportType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Order] [int] NOT NULL,
	[Enabled] [bit] NOT NULL,
 CONSTRAINT [PK_ScheduleReportType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleReportType] ADD  CONSTRAINT [DF_ScheduleReportType_Order]  DEFAULT ((1)) FOR [Order]
ALTER TABLE [dbo].[ScheduleReportType] ADD  CONSTRAINT [DF_ScheduleReportType_Deleted]  DEFAULT ((0)) FOR [Enabled]
