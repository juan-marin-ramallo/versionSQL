/****** Object:  UserDefinedTableType [dbo].[RouteList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[RouteList] AS TABLE(
	[Id] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[StipulatedStartDate] [datetime] NOT NULL,
	[StipulatedEndDate] [datetime] NOT NULL,
	[Comment] [varchar](250) NULL,
	[RecurrenceRule] [varchar](100) NULL,
	[RecurrenceId] [int] NULL,
	[RecurrenceException] [varchar](500) NULL,
	[IsExpanded] [bit] NOT NULL
)
