/****** Object:  UserDefinedTableType [dbo].[DynamicTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[DynamicTableType] AS TABLE(
	[Dynamic] [varchar](100) NOT NULL,
	[Form] [varchar](100) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL
)
