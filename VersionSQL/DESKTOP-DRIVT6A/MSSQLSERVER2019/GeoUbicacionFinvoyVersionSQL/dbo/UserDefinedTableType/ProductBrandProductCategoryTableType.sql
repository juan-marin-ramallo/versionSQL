/****** Object:  UserDefinedTableType [dbo].[ProductBrandProductCategoryTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ProductBrandProductCategoryTableType] AS TABLE(
	[ProductBrandIdentifier] [varchar](50) NOT NULL,
	[NameCategory] [varchar](50) NOT NULL
)
