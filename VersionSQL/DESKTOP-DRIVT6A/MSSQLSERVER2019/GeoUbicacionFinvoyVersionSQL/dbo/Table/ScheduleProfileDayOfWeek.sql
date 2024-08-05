/****** Object:  Table [dbo].[ScheduleProfileDayOfWeek]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleProfileDayOfWeek](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdScheduleProfile] [int] NOT NULL,
	[DayOfWeek] [int] NOT NULL,
 CONSTRAINT [PK__Schedule__3214EC073B5FC2DA] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
