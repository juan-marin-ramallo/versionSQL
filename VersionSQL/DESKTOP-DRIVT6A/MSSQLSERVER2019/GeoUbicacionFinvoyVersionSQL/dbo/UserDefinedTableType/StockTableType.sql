/****** Object:  UserDefinedTableType [dbo].[StockTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[StockTableType] AS TABLE(
	[ProductBarCode] [varchar](100) NOT NULL,
	[ClientId] [varchar](50) NOT NULL,
	[Quantity] [int] NULL,
	[Price] [decimal](18, 2) NULL,
	[Dynamic] [varchar](100) NULL,
	PRIMARY KEY CLUSTERED 
(
	[ProductBarCode] ASC,
	[ClientId] ASC
)WITH (IGNORE_DUP_KEY = ON)
)
