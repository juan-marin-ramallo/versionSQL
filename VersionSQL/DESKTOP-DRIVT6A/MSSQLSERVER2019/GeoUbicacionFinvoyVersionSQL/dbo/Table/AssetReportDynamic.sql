/****** Object:  Table [dbo].[AssetReportDynamic]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssetReportDynamic](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdAsset] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_AssetReportDynamic] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AssetReportDynamic]  WITH CHECK ADD  CONSTRAINT [FK_AssetReportDynamic_Asset] FOREIGN KEY([IdAsset])
REFERENCES [dbo].[Asset] ([Id])
ALTER TABLE [dbo].[AssetReportDynamic] CHECK CONSTRAINT [FK_AssetReportDynamic_Asset]
ALTER TABLE [dbo].[AssetReportDynamic]  WITH CHECK ADD  CONSTRAINT [FK_AssetReportDynamic_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[AssetReportDynamic] CHECK CONSTRAINT [FK_AssetReportDynamic_PersonOfInterest]
ALTER TABLE [dbo].[AssetReportDynamic]  WITH CHECK ADD  CONSTRAINT [FK_AssetReportDynamic_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[AssetReportDynamic] CHECK CONSTRAINT [FK_AssetReportDynamic_PointOfInterest]
