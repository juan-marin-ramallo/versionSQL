/****** Object:  Table [dbo].[OrderReportDocumentTrazability]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[OrderReportDocumentTrazability](
	[IdOrderReport] [int] NOT NULL,
	[IdType] [int] NOT NULL,
	[Status] [smallint] NOT NULL,
	[Comment] [varchar](4096) NULL,
	[ImageName] [varchar](256) NULL,
	[ImageUrl] [varchar](2048) NULL,
 CONSTRAINT [COMP_NAME] PRIMARY KEY CLUSTERED 
(
	[IdOrderReport] ASC,
	[IdType] ASC,
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrderReportDocumentTrazability]  WITH CHECK ADD  CONSTRAINT [FK_OrderReportDocumentTrazability_OrderReport] FOREIGN KEY([IdOrderReport])
REFERENCES [dbo].[OrderReport] ([Id])
ALTER TABLE [dbo].[OrderReportDocumentTrazability] CHECK CONSTRAINT [FK_OrderReportDocumentTrazability_OrderReport]
