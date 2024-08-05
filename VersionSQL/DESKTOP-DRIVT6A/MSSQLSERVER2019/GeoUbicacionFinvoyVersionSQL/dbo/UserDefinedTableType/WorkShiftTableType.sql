/****** Object:  UserDefinedTableType [dbo].[WorkShiftTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[WorkShiftTableType] AS TABLE(
	[IdDayOfWeek] [smallint] NOT NULL,
	[IdWorkShift] [int] NOT NULL,
	[IdRestShift] [int] NULL
)
