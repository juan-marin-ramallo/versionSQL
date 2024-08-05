/****** Object:  Table [dbo].[Product]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Product](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[BarCode] [varchar](100) NOT NULL,
	[Identifier] [varchar](50) NULL,
	[ImageArray] [varbinary](max) NULL,
	[BoxUnits] [int] NULL,
	[BoxBarCode] [varchar](100) NULL,
	[Deleted] [bit] NOT NULL,
	[IdProductBrand] [int] NULL,
	[Indispensable] [bit] NOT NULL,
	[MinSalesQuantity] [int] NULL,
	[MinUnitsPackage] [int] NULL,
	[MaxSalesQuantity] [int] NULL,
	[InStock] [bit] NOT NULL,
	[Column_1] [varchar](100) NULL,
	[Column_2] [varchar](100) NULL,
	[Column_3] [varchar](100) NULL,
	[Column_4] [varchar](100) NULL,
	[Column_5] [varchar](100) NULL,
	[Column_6] [varchar](100) NULL,
	[Column_7] [varchar](100) NULL,
	[Column_8] [varchar](100) NULL,
	[Column_9] [varchar](100) NULL,
	[Column_10] [varchar](100) NULL,
	[Column_11] [varchar](100) NULL,
	[Column_12] [varchar](100) NULL,
	[Column_13] [varchar](100) NULL,
	[Column_14] [varchar](100) NULL,
	[Column_15] [varchar](100) NULL,
	[Column_16] [varchar](100) NULL,
	[Column_17] [varchar](100) NULL,
	[Column_18] [varchar](100) NULL,
	[Column_19] [varchar](100) NULL,
	[Column_20] [varchar](100) NULL,
	[Column_21] [varchar](100) NULL,
	[Column_22] [varchar](100) NULL,
	[Column_23] [varchar](100) NULL,
	[Column_24] [varchar](100) NULL,
	[Column_25] [varchar](100) NULL,
	[TheoricalPrice] [decimal](18, 3) NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NCL_IX_Product_Deleted] ON [dbo].[Product]
(
	[Deleted] ASC
)
INCLUDE([Id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_Indispensable]  DEFAULT ((0)) FOR [Indispensable]
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_OutOfStock]  DEFAULT ((1)) FOR [InStock]
