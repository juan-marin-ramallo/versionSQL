/****** Object:  Table [dbo].[FormPlusCatalog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[FormPlusCatalog](
	[IdFormPlus] [int] NOT NULL,
	[IdCatalog] [int] NOT NULL,
 CONSTRAINT [PK_FormPlusCatalog] PRIMARY KEY CLUSTERED 
(
	[IdFormPlus] ASC,
	[IdCatalog] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FormPlusCatalog]  WITH CHECK ADD  CONSTRAINT [FK_FormPlusCatalog_Catalog] FOREIGN KEY([IdCatalog])
REFERENCES [dbo].[Catalog] ([Id])
ALTER TABLE [dbo].[FormPlusCatalog] CHECK CONSTRAINT [FK_FormPlusCatalog_Catalog]
ALTER TABLE [dbo].[FormPlusCatalog]  WITH CHECK ADD  CONSTRAINT [FK_FormPlusCatalog_FormPlus] FOREIGN KEY([IdFormPlus])
REFERENCES [dbo].[FormPlus] ([Id])
ALTER TABLE [dbo].[FormPlusCatalog] CHECK CONSTRAINT [FK_FormPlusCatalog_FormPlus]
