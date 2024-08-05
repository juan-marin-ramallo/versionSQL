/****** Object:  Table [dbo].[DynamicProductPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DynamicProductPointOfInterest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdDynamic] [int] NOT NULL,
	[IdProduct] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
 CONSTRAINT [PK_DynamicProductPointOfInterest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DynamicProductPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_DynamicProductPointOfInterest_Dynamic] FOREIGN KEY([IdDynamic])
REFERENCES [dbo].[Dynamic] ([Id])
ALTER TABLE [dbo].[DynamicProductPointOfInterest] CHECK CONSTRAINT [FK_DynamicProductPointOfInterest_Dynamic]
ALTER TABLE [dbo].[DynamicProductPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_DynamicProductPointOfInterest_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[DynamicProductPointOfInterest] CHECK CONSTRAINT [FK_DynamicProductPointOfInterest_PointOfInterest]
ALTER TABLE [dbo].[DynamicProductPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_DynamicProductPointOfInterest_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[DynamicProductPointOfInterest] CHECK CONSTRAINT [FK_DynamicProductPointOfInterest_Product]
