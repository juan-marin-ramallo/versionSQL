/****** Object:  Table [dbo].[ProductReportAttributeOption]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductReportAttributeOption](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProductReportAttribute] [int] NOT NULL,
	[Text] [varchar](100) NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_ProductReportCustomAttributeOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductReportAttributeOption] ADD  CONSTRAINT [DF_ProductReportCustomAttributeOption_Default]  DEFAULT ((0)) FOR [IsDefault]
ALTER TABLE [dbo].[ProductReportAttributeOption] ADD  CONSTRAINT [DF_ProductReportCustomAttributeOption_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[ProductReportAttributeOption]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportAttributeOption_ProductReportAttribute] FOREIGN KEY([IdProductReportAttribute])
REFERENCES [dbo].[ProductReportAttribute] ([Id])
ALTER TABLE [dbo].[ProductReportAttributeOption] CHECK CONSTRAINT [FK_ProductReportAttributeOption_ProductReportAttribute]
