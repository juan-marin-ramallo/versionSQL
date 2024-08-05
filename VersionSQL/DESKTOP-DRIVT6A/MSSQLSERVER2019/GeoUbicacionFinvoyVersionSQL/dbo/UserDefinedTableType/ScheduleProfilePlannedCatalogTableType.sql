/****** Object:  UserDefinedTableType [dbo].[ScheduleProfilePlannedCatalogTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ScheduleProfilePlannedCatalogTableType] AS TABLE(
	[ScheduleProfileDescription] [varchar](200) NOT NULL,
	[CatalogProduct] [varchar](100) NOT NULL,
	[Frequency] [varchar](10) NOT NULL,
	[DaysOfWeek] [varchar](100) NULL,
	[RecurrenceNumber] [smallint] NOT NULL,
	[RecurrenceCondition] [varchar](1) NOT NULL,
	[CronExpression] [varchar](200) NOT NULL,
	[Comment] [varchar](250) NULL
)
