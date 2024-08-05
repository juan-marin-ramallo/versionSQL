/****** Object:  Table [dbo].[ScheduleProfileCron]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleProfileCron](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CronExpression] [varchar](200) NOT NULL,
 CONSTRAINT [PK__Schedule__3214EC07D36347CC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
