/****** Object:  Table [dbo].[PersonOfInterestWorkShift]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterestWorkShift](
	[IdPersonOfInterest] [int] NOT NULL,
	[IdDayOfWeek] [smallint] NOT NULL,
	[IdWorkShift] [int] NOT NULL,
	[IdRestShift] [int] NULL,
	[AssignedDate] [datetime] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
 CONSTRAINT [PK_PersonOfInterestWorkShift] PRIMARY KEY CLUSTERED 
(
	[IdPersonOfInterest] ASC,
	[IdDayOfWeek] ASC,
	[IdWorkShift] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PersonOfInterestWorkShift]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestWorkShift_DayOfWeek] FOREIGN KEY([IdDayOfWeek])
REFERENCES [dbo].[DayOfWeek] ([Id])
ALTER TABLE [dbo].[PersonOfInterestWorkShift] CHECK CONSTRAINT [FK_PersonOfInterestWorkShift_DayOfWeek]
ALTER TABLE [dbo].[PersonOfInterestWorkShift]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestWorkShift_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[PersonOfInterestWorkShift] CHECK CONSTRAINT [FK_PersonOfInterestWorkShift_PersonOfInterest]
ALTER TABLE [dbo].[PersonOfInterestWorkShift]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestWorkShift_WorkShift] FOREIGN KEY([IdWorkShift])
REFERENCES [dbo].[WorkShift] ([Id])
ALTER TABLE [dbo].[PersonOfInterestWorkShift] CHECK CONSTRAINT [FK_PersonOfInterestWorkShift_WorkShift]
ALTER TABLE [dbo].[PersonOfInterestWorkShift]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestWorkShift_WorkShift_Rest] FOREIGN KEY([IdRestShift])
REFERENCES [dbo].[WorkShift] ([Id])
ALTER TABLE [dbo].[PersonOfInterestWorkShift] CHECK CONSTRAINT [FK_PersonOfInterestWorkShift_WorkShift_Rest]
