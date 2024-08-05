/****** Object:  Table [dbo].[ProductBrandProductCategory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductBrandProductCategory](
	[IdProductBrand] [int] NOT NULL,
	[IdProductCategory] [int] NOT NULL,
 CONSTRAINT [PK_ProductBrandProductCategory] PRIMARY KEY CLUSTERED 
(
	[IdProductBrand] ASC,
	[IdProductCategory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductBrandProductCategory]  WITH CHECK ADD  CONSTRAINT [FK_ProductBrandProductCategory_ProductBrand] FOREIGN KEY([IdProductBrand])
REFERENCES [dbo].[ProductBrand] ([Id])
ALTER TABLE [dbo].[ProductBrandProductCategory] CHECK CONSTRAINT [FK_ProductBrandProductCategory_ProductBrand]
ALTER TABLE [dbo].[ProductBrandProductCategory]  WITH CHECK ADD  CONSTRAINT [FK_ProductBrandProductCategory_ProductCategory] FOREIGN KEY([IdProductCategory])
REFERENCES [dbo].[ProductCategory] ([Id])
ALTER TABLE [dbo].[ProductBrandProductCategory] CHECK CONSTRAINT [FK_ProductBrandProductCategory_ProductCategory]
