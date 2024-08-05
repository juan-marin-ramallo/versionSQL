/****** Object:  Table [dbo].[FormPlusProduct]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[FormPlusProduct](
	[IdFormPlus] [int] NOT NULL,
	[IdProduct] [int] NOT NULL,
 CONSTRAINT [PK_FormPlusProduct] PRIMARY KEY CLUSTERED 
(
	[IdFormPlus] ASC,
	[IdProduct] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FormPlusProduct]  WITH CHECK ADD  CONSTRAINT [FK_FormPlusProduct_FormPlus] FOREIGN KEY([IdFormPlus])
REFERENCES [dbo].[FormPlus] ([Id])
ALTER TABLE [dbo].[FormPlusProduct] CHECK CONSTRAINT [FK_FormPlusProduct_FormPlus]
ALTER TABLE [dbo].[FormPlusProduct]  WITH CHECK ADD  CONSTRAINT [FK_FormPlusProduct_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[FormPlusProduct] CHECK CONSTRAINT [FK_FormPlusProduct_Product]
