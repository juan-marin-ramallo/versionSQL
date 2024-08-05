/****** Object:  Table [dbo].[AssetPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssetPointOfInterest](
	[IdAsset] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DateFrom] [datetime] NOT NULL,
	[DateTo] [datetime] NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_AssetPointOfInterest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AssetPointOfInterest] ADD  CONSTRAINT [DF_AssetPointOfInterest_DateFrom]  DEFAULT (getutcdate()) FOR [DateFrom]
ALTER TABLE [dbo].[AssetPointOfInterest] ADD  CONSTRAINT [DF_AssetPointOfInterest_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[AssetPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_AssetPointOfInterest_Asset] FOREIGN KEY([IdAsset])
REFERENCES [dbo].[Asset] ([Id])
ALTER TABLE [dbo].[AssetPointOfInterest] CHECK CONSTRAINT [FK_AssetPointOfInterest_Asset]
ALTER TABLE [dbo].[AssetPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_AssetPointOfInterest_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[AssetPointOfInterest] CHECK CONSTRAINT [FK_AssetPointOfInterest_PointOfInterest]
