/****** Object:  Table [dbo].[ShareOfShelfObjective]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ShareOfShelfObjective](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProductCategory] [int] NOT NULL,
	[IdZone] [int] NULL,
	[IdPOIHierarchyLevel1] [int] NULL,
	[IdPOIHierarchyLevel2] [int] NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_ShareOfShelfObjective] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ShareOfShelfObjective] ADD  CONSTRAINT [DF_ShareOfShelfObjective_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[ShareOfShelfObjective]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfObjective_POIHierarchyLevel1] FOREIGN KEY([IdPOIHierarchyLevel1])
REFERENCES [dbo].[POIHierarchyLevel1] ([Id])
ALTER TABLE [dbo].[ShareOfShelfObjective] CHECK CONSTRAINT [FK_ShareOfShelfObjective_POIHierarchyLevel1]
ALTER TABLE [dbo].[ShareOfShelfObjective]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfObjective_POIHierarchyLevel2] FOREIGN KEY([IdPOIHierarchyLevel2])
REFERENCES [dbo].[POIHierarchyLevel2] ([Id])
ALTER TABLE [dbo].[ShareOfShelfObjective] CHECK CONSTRAINT [FK_ShareOfShelfObjective_POIHierarchyLevel2]
ALTER TABLE [dbo].[ShareOfShelfObjective]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfObjective_ProductCategory] FOREIGN KEY([IdProductCategory])
REFERENCES [dbo].[ProductCategory] ([Id])
ALTER TABLE [dbo].[ShareOfShelfObjective] CHECK CONSTRAINT [FK_ShareOfShelfObjective_ProductCategory]
ALTER TABLE [dbo].[ShareOfShelfObjective]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfObjective_Zone] FOREIGN KEY([IdZone])
REFERENCES [dbo].[Zone] ([Id])
ALTER TABLE [dbo].[ShareOfShelfObjective] CHECK CONSTRAINT [FK_ShareOfShelfObjective_Zone]
