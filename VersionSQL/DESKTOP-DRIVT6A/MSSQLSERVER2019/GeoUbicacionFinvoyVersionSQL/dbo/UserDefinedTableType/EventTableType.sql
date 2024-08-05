/****** Object:  UserDefinedTableType [dbo].[EventTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[EventTableType] AS TABLE(
	[Date] [datetime] NULL,
	[IdPersonOfInterest] [int] NULL,
	[Type] [varchar](10) NULL
)
