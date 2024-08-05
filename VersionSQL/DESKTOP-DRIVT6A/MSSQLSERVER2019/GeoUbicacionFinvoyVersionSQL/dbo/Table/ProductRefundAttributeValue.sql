/****** Object:  Table [dbo].[ProductRefundAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductRefundAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [varchar](max) NULL,
	[IdProductRefund] [int] NULL,
	[IdProductRefundAttribute] [int] NULL,
	[IdProductRefundAttributeOption] [int] NULL,
	[ImageName] [varchar](100) NULL,
	[ImageEncoded] [varbinary](max) NULL,
	[ImageUrl] [varchar](500) NULL,
 CONSTRAINT [PK_ProductRefundAttributeValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[ProductRefundAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductRefundAttributeValue_ProductRefund] FOREIGN KEY([IdProductRefund])
REFERENCES [dbo].[ProductRefund] ([Id])
ALTER TABLE [dbo].[ProductRefundAttributeValue] CHECK CONSTRAINT [FK_ProductRefundAttributeValue_ProductRefund]
ALTER TABLE [dbo].[ProductRefundAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductRefundAttributeValue_ProductRefundAttribute] FOREIGN KEY([IdProductRefundAttribute])
REFERENCES [dbo].[ProductRefundAttribute] ([Id])
ALTER TABLE [dbo].[ProductRefundAttributeValue] CHECK CONSTRAINT [FK_ProductRefundAttributeValue_ProductRefundAttribute]
ALTER TABLE [dbo].[ProductRefundAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductRefundAttributeValue_ProductRefundAttributeOption] FOREIGN KEY([IdProductRefundAttributeOption])
REFERENCES [dbo].[ProductRefundAttributeOption] ([Id])
ALTER TABLE [dbo].[ProductRefundAttributeValue] CHECK CONSTRAINT [FK_ProductRefundAttributeValue_ProductRefundAttributeOption]
