/****** Object:  Table [dbo].[ProductRefund]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductRefund](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdProduct] [int] NOT NULL,
	[Quantity] [int] NULL,
	[Description] [varchar](230) NULL,
	[IdRefundOption] [int] NULL,
 CONSTRAINT [PK_ProductRefund] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductRefund]  WITH CHECK ADD  CONSTRAINT [FK_ProductRefund_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[ProductRefund] CHECK CONSTRAINT [FK_ProductRefund_PersonOfInterest]
ALTER TABLE [dbo].[ProductRefund]  WITH CHECK ADD  CONSTRAINT [FK_ProductRefund_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[ProductRefund] CHECK CONSTRAINT [FK_ProductRefund_PointOfInterest]
ALTER TABLE [dbo].[ProductRefund]  WITH CHECK ADD  CONSTRAINT [FK_ProductRefund_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[ProductRefund] CHECK CONSTRAINT [FK_ProductRefund_Product]
ALTER TABLE [dbo].[ProductRefund]  WITH CHECK ADD  CONSTRAINT [FK_ProductRefund_ProductRefundOptions] FOREIGN KEY([IdRefundOption])
REFERENCES [dbo].[ProductRefundOptions] ([Id])
ALTER TABLE [dbo].[ProductRefund] CHECK CONSTRAINT [FK_ProductRefund_ProductRefundOptions]
