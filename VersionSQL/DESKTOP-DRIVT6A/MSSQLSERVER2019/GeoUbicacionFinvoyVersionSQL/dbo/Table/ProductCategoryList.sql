/****** Object:  Table [dbo].[ProductCategoryList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductCategoryList](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProduct] [int] NOT NULL,
	[IdProductCategory] [int] NOT NULL,
 CONSTRAINT [PK_ProductCategoryList] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NCL_IX_ProductCategoryList_IdProduct] ON [dbo].[ProductCategoryList]
(
	[IdProduct] ASC
)
INCLUDE([IdProductCategory]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[ProductCategoryList]  WITH CHECK ADD  CONSTRAINT [FK_ProductCategoryList_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[ProductCategoryList] CHECK CONSTRAINT [FK_ProductCategoryList_Product]
ALTER TABLE [dbo].[ProductCategoryList]  WITH CHECK ADD  CONSTRAINT [FK_ProductCategoryList_ProductCategory] FOREIGN KEY([IdProductCategory])
REFERENCES [dbo].[ProductCategory] ([Id])
ALTER TABLE [dbo].[ProductCategoryList] CHECK CONSTRAINT [FK_ProductCategoryList_ProductCategory]
