/****** Object:  UserDefinedTableType [dbo].[ProductNullValuesTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ProductNullValuesTableType] AS TABLE(
	[Id] [varchar](50) NOT NULL,
	[ImageArray] [varbinary](max) NULL,
	[Name] [varchar](100) NOT NULL,
	[BarCode] [varchar](100) NOT NULL,
	[BoxUnits] [int] NULL,
	[BoxBarCode] [varchar](100) NULL,
	[BrandIdentifier] [varchar](50) NULL,
	[Indispensable] [bit] NULL,
	[MinSalesQuantity] [int] NULL,
	[MinUnitsPackage] [int] NULL,
	[MaxSalesQuantity] [int] NULL,
	[InStock] [bit] NULL,
	[ProductCategory1] [varchar](100) NULL,
	[ProductCategory2] [varchar](100) NULL,
	[ProductCategory3] [varchar](100) NULL,
	[ProductCategory4] [varchar](100) NULL,
	[ProductCategory5] [varchar](100) NULL
)
