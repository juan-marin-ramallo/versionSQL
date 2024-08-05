/****** Object:  Table [dbo].[ProductMissingReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductMissingReport](
	[IdMissingProductPoi] [int] NOT NULL,
	[IdProduct] [int] NOT NULL,
 CONSTRAINT [PK_ProductMissingReport] PRIMARY KEY CLUSTERED 
(
	[IdMissingProductPoi] ASC,
	[IdProduct] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductMissingReport]  WITH CHECK ADD  CONSTRAINT [FK_ProductMissingReport_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[ProductMissingReport] CHECK CONSTRAINT [FK_ProductMissingReport_Product]
ALTER TABLE [dbo].[ProductMissingReport]  WITH CHECK ADD  CONSTRAINT [FK_ProductMissingReport_ProductMissingPointOfInterest] FOREIGN KEY([IdMissingProductPoi])
REFERENCES [dbo].[ProductMissingPointOfInterest] ([Id])
ALTER TABLE [dbo].[ProductMissingReport] CHECK CONSTRAINT [FK_ProductMissingReport_ProductMissingPointOfInterest]
