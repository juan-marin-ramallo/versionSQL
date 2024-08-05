/****** Object:  Table [dbo].[PersonOfInterestSchedule]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterestSchedule](
	[IdPersonOfInterest] [int] NOT NULL,
	[IdDayOfWeek] [smallint] NOT NULL,
	[WorkHours] [time](7) NOT NULL,
	[RestHours] [time](7) NULL,
	[FromHour] [time](7) NULL,
	[ToHour] [time](7) NULL,
 CONSTRAINT [PK_StockerSchedule] PRIMARY KEY CLUSTERED 
(
	[IdPersonOfInterest] ASC,
	[IdDayOfWeek] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
