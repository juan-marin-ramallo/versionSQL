/****** Object:  UserDefinedTableType [Tzdb].[IntervalTable]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [Tzdb].[IntervalTable] AS TABLE(
	[UtcStart] [datetime2](0) NOT NULL,
	[UtcEnd] [datetime2](0) NOT NULL,
	[LocalStart] [datetime2](0) NOT NULL,
	[LocalEnd] [datetime2](0) NOT NULL,
	[OffsetMinutes] [smallint] NOT NULL,
	[Abbreviation] [varchar](10) NOT NULL
)
