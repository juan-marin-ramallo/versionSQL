/****** Object:  UserDefinedTableType [dbo].[ScheduleProfileTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ScheduleProfileTableType] AS TABLE(
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Frequency] [varchar](10) NOT NULL,
	[DaysOfWeek] [varchar](100) NULL,
	[RecurrenceNumber] [smallint] NOT NULL,
	[RecurrenceCondition] [varchar](1) NOT NULL,
	[CronExpression] [varchar](200) NOT NULL,
	[Actions] [varchar](200) NOT NULL,
	[SKUsections] [varchar](20) NULL,
	[Note1Action] [bit] NOT NULL,
	[Note2Action] [bit] NOT NULL,
	[AllPersonOfInterest] [bit] NOT NULL,
	[AllPointOfInterest] [bit] NOT NULL
)
