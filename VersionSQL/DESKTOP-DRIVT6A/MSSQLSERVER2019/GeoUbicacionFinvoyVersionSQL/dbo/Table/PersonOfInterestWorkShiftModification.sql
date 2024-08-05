/****** Object:  Table [dbo].[PersonOfInterestWorkShiftModification]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterestWorkShiftModification](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdDayOfWeek] [int] NOT NULL,
	[IdCurrentWorkShift] [int] NULL,
	[CurrentWorkShiftStartTime] [time](7) NULL,
	[CurrentWorkShiftEndTime] [time](7) NULL,
	[CurrentWorkShiftAssignedDate] [datetime] NULL,
	[IdWorkShiftRecurrenceType] [smallint] NOT NULL,
	[IdNewWorkShift] [int] NULL,
	[NewWorkShiftStartTime] [time](7) NULL,
	[NewWorkShiftEndTime] [time](7) NULL,
	[NewWorkShiftAssignedDate] [datetime] NULL,
	[IdWorkShiftRequestor] [smallint] NOT NULL,
 CONSTRAINT [PK_PersonOfInterestWorkShiftModification] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
