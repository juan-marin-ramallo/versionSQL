/****** Object:  Table [dbo].[CatalogPersonOfInterestPermission]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CatalogPersonOfInterestPermission](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCatalog] [int] NOT NULL,
	[IdPersonOfInterestPermission] [int] NOT NULL,
 CONSTRAINT [PK_CatalogPersonOfInterestPermission] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CatalogPersonOfInterestPermission]  WITH CHECK ADD  CONSTRAINT [FK_CatalogPersonOfInterestPermission_Catalog] FOREIGN KEY([IdCatalog])
REFERENCES [dbo].[Catalog] ([Id])
ALTER TABLE [dbo].[CatalogPersonOfInterestPermission] CHECK CONSTRAINT [FK_CatalogPersonOfInterestPermission_Catalog]
ALTER TABLE [dbo].[CatalogPersonOfInterestPermission]  WITH CHECK ADD  CONSTRAINT [FK_CatalogPersonOfInterestPermission_PersonOfInterestPermission] FOREIGN KEY([IdPersonOfInterestPermission])
REFERENCES [dbo].[PersonOfInterestPermission] ([Id])
ALTER TABLE [dbo].[CatalogPersonOfInterestPermission] CHECK CONSTRAINT [FK_CatalogPersonOfInterestPermission_PersonOfInterestPermission]
