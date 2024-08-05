/****** Object:  Table [dbo].[AssortmentReportProduct]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssortmentReportProduct](
	[IdAssortmentReport] [int] NOT NULL,
	[IdProduct] [int] NOT NULL,
	[Complies] [bit] NOT NULL,
 CONSTRAINT [PK_AssortmentReportProduct] PRIMARY KEY CLUSTERED 
(
	[IdAssortmentReport] ASC,
	[IdProduct] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AssortmentReportProduct]  WITH CHECK ADD  CONSTRAINT [FK_AssortmentReportProduct_AssortmentReport] FOREIGN KEY([IdAssortmentReport])
REFERENCES [dbo].[AssortmentReport] ([Id])
ALTER TABLE [dbo].[AssortmentReportProduct] CHECK CONSTRAINT [FK_AssortmentReportProduct_AssortmentReport]
ALTER TABLE [dbo].[AssortmentReportProduct]  WITH CHECK ADD  CONSTRAINT [FK_AssortmentReportProduct_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[AssortmentReportProduct] CHECK CONSTRAINT [FK_AssortmentReportProduct_Product]
