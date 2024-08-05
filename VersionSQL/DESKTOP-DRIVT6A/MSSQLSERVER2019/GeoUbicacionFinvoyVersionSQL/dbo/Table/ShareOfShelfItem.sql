/****** Object:  Table [dbo].[ShareOfShelfItem]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ShareOfShelfItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdShareOfShelf] [int] NOT NULL,
	[IdProduct] [int] NULL,
	[IdProductBrand] [int] NULL,
	[Total] [decimal](10, 2) NOT NULL,
 CONSTRAINT [PK_ShareOfShelfItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ShareOfShelfItem]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfItem_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[ShareOfShelfItem] CHECK CONSTRAINT [FK_ShareOfShelfItem_Product]
ALTER TABLE [dbo].[ShareOfShelfItem]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfItem_ProductBrand] FOREIGN KEY([IdProductBrand])
REFERENCES [dbo].[ProductBrand] ([Id])
ALTER TABLE [dbo].[ShareOfShelfItem] CHECK CONSTRAINT [FK_ShareOfShelfItem_ProductBrand]
ALTER TABLE [dbo].[ShareOfShelfItem]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfItem_ShareOfShelfReport] FOREIGN KEY([IdShareOfShelf])
REFERENCES [dbo].[ShareOfShelfReport] ([Id])
ALTER TABLE [dbo].[ShareOfShelfItem] CHECK CONSTRAINT [FK_ShareOfShelfItem_ShareOfShelfReport]
