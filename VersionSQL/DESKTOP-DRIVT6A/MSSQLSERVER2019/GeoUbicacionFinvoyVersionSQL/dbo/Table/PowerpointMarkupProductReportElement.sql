/****** Object:  Table [dbo].[PowerpointMarkupProductReportElement]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PowerpointMarkupProductReportElement](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPowerpointMarkupProductReport] [int] NOT NULL,
	[PageIndex] [int] NOT NULL,
	[IdPowerpointMarkupElement] [int] NOT NULL,
	[IdProductReportAttribute] [int] NOT NULL,
	[ShowTitle] [bit] NOT NULL,
 CONSTRAINT [PK_PowerpointMarkupProductReportElement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PowerpointMarkupProductReportElement]  WITH CHECK ADD  CONSTRAINT [FK_PowerpointMarkupProductReportElement_PowerpointMarkupElement] FOREIGN KEY([IdPowerpointMarkupElement])
REFERENCES [dbo].[PowerpointMarkupElement] ([Id])
ALTER TABLE [dbo].[PowerpointMarkupProductReportElement] CHECK CONSTRAINT [FK_PowerpointMarkupProductReportElement_PowerpointMarkupElement]
ALTER TABLE [dbo].[PowerpointMarkupProductReportElement]  WITH CHECK ADD  CONSTRAINT [FK_PowerpointMarkupProductReportElement_PowerpointMarkupProductReport] FOREIGN KEY([IdPowerpointMarkupProductReport])
REFERENCES [dbo].[PowerpointMarkupProductReport] ([Id])
ALTER TABLE [dbo].[PowerpointMarkupProductReportElement] CHECK CONSTRAINT [FK_PowerpointMarkupProductReportElement_PowerpointMarkupProductReport]
ALTER TABLE [dbo].[PowerpointMarkupProductReportElement]  WITH CHECK ADD  CONSTRAINT [FK_PowerpointMarkupProductReportElement_ProductReportAttribute] FOREIGN KEY([IdProductReportAttribute])
REFERENCES [dbo].[ProductReportAttribute] ([Id])
ALTER TABLE [dbo].[PowerpointMarkupProductReportElement] CHECK CONSTRAINT [FK_PowerpointMarkupProductReportElement_ProductReportAttribute]
