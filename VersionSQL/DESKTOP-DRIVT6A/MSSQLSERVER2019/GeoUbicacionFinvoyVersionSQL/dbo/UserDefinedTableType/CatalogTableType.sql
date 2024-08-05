/****** Object:  UserDefinedTableType [dbo].[CatalogTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[CatalogTableType] AS TABLE(
	[IdCatalog] [int] NOT NULL,
	[ProductBarCode] [varchar](100) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[IdCatalog] ASC,
	[ProductBarCode] ASC
)WITH (IGNORE_DUP_KEY = ON)
)
