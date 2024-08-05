/****** Object:  Table [dbo].[ProductPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductPointOfInterest](
	[IdProduct] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[TheoricalStock] [int] NULL,
	[TheoricalPrice] [decimal](18, 2) NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCatalog] [int] NULL,
	[Dynamic] [varchar](100) NULL,
 CONSTRAINT [PK_ProductPointOfInterest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_ProductPointOfInterest] UNIQUE NONCLUSTERED 
(
	[IdCatalog] ASC,
	[IdPointOfInterest] ASC,
	[IdProduct] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_ProductPointOfInterest_Catalog] FOREIGN KEY([IdCatalog])
REFERENCES [dbo].[Catalog] ([Id])
ALTER TABLE [dbo].[ProductPointOfInterest] CHECK CONSTRAINT [FK_ProductPointOfInterest_Catalog]
ALTER TABLE [dbo].[ProductPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_ProductPointOfInterest_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[ProductPointOfInterest] CHECK CONSTRAINT [FK_ProductPointOfInterest_PointOfInterest]
ALTER TABLE [dbo].[ProductPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_ProductPointOfInterst_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[ProductPointOfInterest] CHECK CONSTRAINT [FK_ProductPointOfInterst_Product]
