/****** Object:  UserDefinedTableType [dbo].[PowerPointMarkupElement]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[PowerPointMarkupElement] AS TABLE(
	[IdPowerpointMarkupElement] [int] NOT NULL,
	[IdElement] [int] NOT NULL,
	[PageIndex] [int] NOT NULL
)
