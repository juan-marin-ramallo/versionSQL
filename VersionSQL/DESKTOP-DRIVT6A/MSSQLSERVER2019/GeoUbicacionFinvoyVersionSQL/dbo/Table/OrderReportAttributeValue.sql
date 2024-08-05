/****** Object:  Table [dbo].[OrderReportAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[OrderReportAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdOrderReport] [int] NULL,
	[IdProduct] [int] NULL,
	[IdOrderReportAttribute] [int] NULL,
	[IdOrderReportAttributeOption] [int] NULL,
	[ImageName] [varchar](100) NULL,
	[ImageUrl] [varchar](5000) NULL,
	[ImageEncoded] [varbinary](max) NULL,
	[Value] [varchar](max) NULL,
 CONSTRAINT [PK_OrderReportAttributeValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[OrderReportAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_OrderReportAttributeValue_OrderReport] FOREIGN KEY([IdOrderReport])
REFERENCES [dbo].[OrderReport] ([Id])
ALTER TABLE [dbo].[OrderReportAttributeValue] CHECK CONSTRAINT [FK_OrderReportAttributeValue_OrderReport]
ALTER TABLE [dbo].[OrderReportAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_OrderReportAttributeValue_OrderReportAttribute] FOREIGN KEY([IdOrderReportAttribute])
REFERENCES [dbo].[OrderReportAttribute] ([Id])
ALTER TABLE [dbo].[OrderReportAttributeValue] CHECK CONSTRAINT [FK_OrderReportAttributeValue_OrderReportAttribute]
ALTER TABLE [dbo].[OrderReportAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_OrderReportAttributeValue_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[OrderReportAttributeValue] CHECK CONSTRAINT [FK_OrderReportAttributeValue_Product]
