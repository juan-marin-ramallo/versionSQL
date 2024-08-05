/****** Object:  Table [dbo].[CatalogProduct]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CatalogProduct](
	[IdCatalog] [int] NOT NULL,
	[IdProduct] [int] NOT NULL,
 CONSTRAINT [PK_CatalogProduct] PRIMARY KEY CLUSTERED 
(
	[IdCatalog] ASC,
	[IdProduct] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CatalogProduct]  WITH CHECK ADD  CONSTRAINT [FK_CatalogProduct_Catalog] FOREIGN KEY([IdCatalog])
REFERENCES [dbo].[Catalog] ([Id])
ALTER TABLE [dbo].[CatalogProduct] CHECK CONSTRAINT [FK_CatalogProduct_Catalog]
ALTER TABLE [dbo].[CatalogProduct]  WITH CHECK ADD  CONSTRAINT [FK_CatalogProduct_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[CatalogProduct] CHECK CONSTRAINT [FK_CatalogProduct_Product]
