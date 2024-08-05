/****** Object:  UserDefinedTableType [dbo].[AssetTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[AssetTableType] AS TABLE(
	[Id] [varchar](50) NOT NULL,
	[ImageArray] [varbinary](max) NULL,
	[Name] [varchar](50) NOT NULL,
	[BarCode] [varchar](100) NOT NULL,
	[TypeName] [varchar](100) NULL,
	[CompanyIdentifier] [varchar](50) NULL,
	[CategoryId] [varchar](50) NULL,
	[SubCategoryId] [varchar](50) NULL,
	PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
