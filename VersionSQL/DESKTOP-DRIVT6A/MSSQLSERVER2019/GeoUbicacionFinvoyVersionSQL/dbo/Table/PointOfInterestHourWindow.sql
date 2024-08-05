/****** Object:  Table [dbo].[PointOfInterestHourWindow]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PointOfInterestHourWindow](
	[IdPointOfInterest] [int] NOT NULL,
	[IdDayOfWeek] [smallint] NOT NULL,
	[FromHour] [time](7) NOT NULL,
	[ToHour] [time](7) NOT NULL,
 CONSTRAINT [PK_PointOfInterestHourWindow] PRIMARY KEY CLUSTERED 
(
	[IdPointOfInterest] ASC,
	[IdDayOfWeek] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PointOfInterestHourWindow]  WITH NOCHECK ADD  CONSTRAINT [FK_PointOfInterestHourWindow_DayOfWeek] FOREIGN KEY([IdDayOfWeek])
REFERENCES [dbo].[DayOfWeek] ([Id])
ALTER TABLE [dbo].[PointOfInterestHourWindow] CHECK CONSTRAINT [FK_PointOfInterestHourWindow_DayOfWeek]
ALTER TABLE [dbo].[PointOfInterestHourWindow]  WITH NOCHECK ADD  CONSTRAINT [FK_PointOfInterestHourWindow_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[PointOfInterestHourWindow] CHECK CONSTRAINT [FK_PointOfInterestHourWindow_PointOfInterest]
