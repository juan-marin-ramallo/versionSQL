/****** Object:  Table [dbo].[OrderReportProductQuantity]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[OrderReportProductQuantity](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdOrderReport] [int] NULL,
	[IdProduct] [int] NULL,
	[Quantity] [int] NULL,
 CONSTRAINT [PK_OrderReportProductQuantity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrderReportProductQuantity]  WITH CHECK ADD  CONSTRAINT [FK_OrderReportProductQuantity_OrderReport] FOREIGN KEY([IdOrderReport])
REFERENCES [dbo].[OrderReport] ([Id])
ALTER TABLE [dbo].[OrderReportProductQuantity] CHECK CONSTRAINT [FK_OrderReportProductQuantity_OrderReport]
ALTER TABLE [dbo].[OrderReportProductQuantity]  WITH CHECK ADD  CONSTRAINT [FK_OrderReportProductQuantity_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[OrderReportProductQuantity] CHECK CONSTRAINT [FK_OrderReportProductQuantity_Product]
