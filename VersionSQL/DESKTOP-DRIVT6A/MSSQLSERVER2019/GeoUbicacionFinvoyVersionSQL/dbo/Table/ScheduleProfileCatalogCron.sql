/****** Object:  Table [dbo].[ScheduleProfileCatalogCron]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleProfileCatalogCron](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CronExpression] [varchar](200) NOT NULL,
 CONSTRAINT [PK_ScheduleProfileCatalogCron] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
