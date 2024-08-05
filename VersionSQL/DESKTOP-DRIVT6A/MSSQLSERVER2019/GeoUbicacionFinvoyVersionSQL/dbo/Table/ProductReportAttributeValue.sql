/****** Object:  Table [dbo].[ProductReportAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductReportAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [varchar](max) NULL,
	[IdProductReport] [int] NOT NULL,
	[IdProductReportAttribute] [int] NOT NULL,
	[IdProductReportAttributeOption] [int] NULL,
	[ImageName] [varchar](100) NULL,
	[ImageEncoded] [varbinary](max) NULL,
	[ImageUrl] [varchar](5000) NULL,
 CONSTRAINT [PK_ProductReportCustomAttributeValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NCL_IX_ProductReportAttributeValue_IdProductReport] ON [dbo].[ProductReportAttributeValue]
(
	[IdProductReport] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[ProductReportAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportAttributeValue_ProductReport] FOREIGN KEY([IdProductReport])
REFERENCES [dbo].[ProductReportDynamic] ([Id])
ALTER TABLE [dbo].[ProductReportAttributeValue] CHECK CONSTRAINT [FK_ProductReportAttributeValue_ProductReport]
ALTER TABLE [dbo].[ProductReportAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportAttributeValue_ProductReportAttribute] FOREIGN KEY([IdProductReportAttribute])
REFERENCES [dbo].[ProductReportAttribute] ([Id])
ALTER TABLE [dbo].[ProductReportAttributeValue] CHECK CONSTRAINT [FK_ProductReportAttributeValue_ProductReportAttribute]
ALTER TABLE [dbo].[ProductReportAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportAttributeValue_ProductReportAttributeOption] FOREIGN KEY([IdProductReportAttributeOption])
REFERENCES [dbo].[ProductReportAttributeOption] ([Id])
ALTER TABLE [dbo].[ProductReportAttributeValue] CHECK CONSTRAINT [FK_ProductReportAttributeValue_ProductReportAttributeOption]
