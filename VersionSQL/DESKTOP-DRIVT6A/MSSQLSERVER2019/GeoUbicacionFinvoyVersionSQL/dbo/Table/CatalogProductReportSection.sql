/****** Object:  Table [dbo].[CatalogProductReportSection]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CatalogProductReportSection](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCatalog] [int] NOT NULL,
	[IdProductReportSection] [int] NOT NULL,
 CONSTRAINT [PK__CatalogP__3214EC07ABA8D2E6] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CatalogProductReportSection]  WITH CHECK ADD  CONSTRAINT [FK__CatalogPr__IdCat__7C2624A9] FOREIGN KEY([IdCatalog])
REFERENCES [dbo].[Catalog] ([Id])
ALTER TABLE [dbo].[CatalogProductReportSection] CHECK CONSTRAINT [FK__CatalogPr__IdCat__7C2624A9]
ALTER TABLE [dbo].[CatalogProductReportSection]  WITH CHECK ADD  CONSTRAINT [FK__CatalogPr__IdPro__7D1A48E2] FOREIGN KEY([IdProductReportSection])
REFERENCES [dbo].[ProductReportSection] ([Id])
ALTER TABLE [dbo].[CatalogProductReportSection] CHECK CONSTRAINT [FK__CatalogPr__IdPro__7D1A48E2]
