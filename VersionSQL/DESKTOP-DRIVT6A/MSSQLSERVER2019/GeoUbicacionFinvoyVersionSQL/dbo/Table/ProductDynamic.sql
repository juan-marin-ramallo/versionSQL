/****** Object:  Table [dbo].[ProductDynamic]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductDynamic](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Dynamic] [varchar](100) NOT NULL,
	[IdProduct] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[IdProductReportSection] [int] NULL,
	[IdForm] [int] NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_ProductDynamic] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductDynamic]  WITH CHECK ADD  CONSTRAINT [FK_ProductDynamic_Form] FOREIGN KEY([IdForm])
REFERENCES [dbo].[Form] ([Id])
ALTER TABLE [dbo].[ProductDynamic] CHECK CONSTRAINT [FK_ProductDynamic_Form]
ALTER TABLE [dbo].[ProductDynamic]  WITH CHECK ADD  CONSTRAINT [FK_ProductDynamic_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[ProductDynamic] CHECK CONSTRAINT [FK_ProductDynamic_PointOfInterest]
ALTER TABLE [dbo].[ProductDynamic]  WITH CHECK ADD  CONSTRAINT [FK_ProductDynamic_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[ProductDynamic] CHECK CONSTRAINT [FK_ProductDynamic_Product]
ALTER TABLE [dbo].[ProductDynamic]  WITH CHECK ADD  CONSTRAINT [FK_ProductDynamic_ProductReportSection] FOREIGN KEY([IdProductReportSection])
REFERENCES [dbo].[ProductReportSection] ([Id])
ALTER TABLE [dbo].[ProductDynamic] CHECK CONSTRAINT [FK_ProductDynamic_ProductReportSection]
