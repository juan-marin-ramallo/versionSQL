/****** Object:  Table [dbo].[ProductRefundAttributeOption]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductRefundAttributeOption](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProductRefundAttribute] [int] NULL,
	[Text] [varchar](100) NULL,
	[IsDefault] [bit] NULL,
	[Deleted] [bit] NULL,
 CONSTRAINT [PK_ProductRefundAttributeOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductRefundAttributeOption]  WITH CHECK ADD  CONSTRAINT [FK_ProductRefundAttributeOption_ProductRefundAttribute] FOREIGN KEY([IdProductRefundAttribute])
REFERENCES [dbo].[ProductRefundAttribute] ([Id])
ALTER TABLE [dbo].[ProductRefundAttributeOption] CHECK CONSTRAINT [FK_ProductRefundAttributeOption_ProductRefundAttribute]
