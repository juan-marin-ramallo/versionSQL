/****** Object:  Table [dbo].[ShareOfShelfProductCategory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ShareOfShelfProductCategory](
	[IdShareOfShelf] [int] NOT NULL,
	[IdProductCategory] [int] NOT NULL,
 CONSTRAINT [PK_ShareOfShelfProductCategory] PRIMARY KEY CLUSTERED 
(
	[IdShareOfShelf] ASC,
	[IdProductCategory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ShareOfShelfProductCategory]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfProductCategory_ProductCategory] FOREIGN KEY([IdProductCategory])
REFERENCES [dbo].[ProductCategory] ([Id])
ALTER TABLE [dbo].[ShareOfShelfProductCategory] CHECK CONSTRAINT [FK_ShareOfShelfProductCategory_ProductCategory]
ALTER TABLE [dbo].[ShareOfShelfProductCategory]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfProductCategory_ShareOfShelfReport] FOREIGN KEY([IdShareOfShelf])
REFERENCES [dbo].[ShareOfShelfReport] ([Id])
ALTER TABLE [dbo].[ShareOfShelfProductCategory] CHECK CONSTRAINT [FK_ShareOfShelfProductCategory_ShareOfShelfReport]
