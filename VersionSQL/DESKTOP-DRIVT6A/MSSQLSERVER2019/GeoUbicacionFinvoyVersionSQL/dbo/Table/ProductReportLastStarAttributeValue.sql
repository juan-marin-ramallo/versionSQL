/****** Object:  Table [dbo].[ProductReportLastStarAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductReportLastStarAttributeValue](
	[IdPointOfInterest] [int] NOT NULL,
	[IdProduct] [int] NOT NULL,
	[IdProductReportAttribute] [int] NOT NULL,
	[Value] [varchar](max) NULL,
	[Date] [datetime] NOT NULL,
	[IdPersonOfInterest] [int] NULL,
 CONSTRAINT [PK_ProductReportLastAttributeValue] PRIMARY KEY CLUSTERED 
(
	[IdPointOfInterest] ASC,
	[IdProduct] ASC,
	[IdProductReportAttribute] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[ProductReportLastStarAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportLastAttributeValue_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[ProductReportLastStarAttributeValue] CHECK CONSTRAINT [FK_ProductReportLastAttributeValue_PersonOfInterest]
ALTER TABLE [dbo].[ProductReportLastStarAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportLastAttributeValue_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[ProductReportLastStarAttributeValue] CHECK CONSTRAINT [FK_ProductReportLastAttributeValue_PointOfInterest]
ALTER TABLE [dbo].[ProductReportLastStarAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportLastAttributeValue_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[ProductReportLastStarAttributeValue] CHECK CONSTRAINT [FK_ProductReportLastAttributeValue_Product]
ALTER TABLE [dbo].[ProductReportLastStarAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportLastAttributeValue_ProductReportAttribute] FOREIGN KEY([IdProductReportAttribute])
REFERENCES [dbo].[ProductReportAttribute] ([Id])
ALTER TABLE [dbo].[ProductReportLastStarAttributeValue] CHECK CONSTRAINT [FK_ProductReportLastAttributeValue_ProductReportAttribute]
