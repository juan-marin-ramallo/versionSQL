/****** Object:  Table [dbo].[CatalogPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CatalogPointOfInterest](
	[IdCatalog] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
 CONSTRAINT [PK_CatalogPointOfInterest] PRIMARY KEY CLUSTERED 
(
	[IdCatalog] ASC,
	[IdPointOfInterest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
