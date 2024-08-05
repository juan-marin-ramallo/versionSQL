/****** Object:  UserDefinedTableType [dbo].[ProductCategoryTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ProductCategoryTableType] AS TABLE(
	[Name] [varchar](50) NULL,
	[Description] [varchar](250) NULL,
	[IdUser] [int] NULL,
	[Order] [int] NULL
)
