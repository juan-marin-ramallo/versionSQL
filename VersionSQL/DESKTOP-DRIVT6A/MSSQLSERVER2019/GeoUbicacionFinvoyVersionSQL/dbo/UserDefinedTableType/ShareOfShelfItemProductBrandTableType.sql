/****** Object:  UserDefinedTableType [dbo].[ShareOfShelfItemProductBrandTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ShareOfShelfItemProductBrandTableType] AS TABLE(
	[IdProductBrand] [int] NOT NULL,
	[Total] [decimal](10, 2) NOT NULL
)
