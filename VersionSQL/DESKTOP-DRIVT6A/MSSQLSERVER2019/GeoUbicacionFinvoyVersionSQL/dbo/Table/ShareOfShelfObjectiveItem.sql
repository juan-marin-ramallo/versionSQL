/****** Object:  Table [dbo].[ShareOfShelfObjectiveItem]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ShareOfShelfObjectiveItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdShareOfShelfObjective] [int] NOT NULL,
	[IdProductBrand] [int] NOT NULL,
	[Value] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK_ShareOfShelfObjectiveItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ShareOfShelfObjectiveItem]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfObjectiveItem_ProductBrand] FOREIGN KEY([IdProductBrand])
REFERENCES [dbo].[ProductBrand] ([Id])
ALTER TABLE [dbo].[ShareOfShelfObjectiveItem] CHECK CONSTRAINT [FK_ShareOfShelfObjectiveItem_ProductBrand]
ALTER TABLE [dbo].[ShareOfShelfObjectiveItem]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfObjectiveItem_ShareOfShelfObjective] FOREIGN KEY([IdShareOfShelfObjective])
REFERENCES [dbo].[ShareOfShelfObjective] ([Id])
ALTER TABLE [dbo].[ShareOfShelfObjectiveItem] CHECK CONSTRAINT [FK_ShareOfShelfObjectiveItem_ShareOfShelfObjective]
