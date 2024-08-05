/****** Object:  Table [dbo].[AssetReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssetReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdAsset] [int] NULL,
	[IdPersonOfInterest] [int] NULL,
	[IdPointOfInterest] [int] NULL,
	[Image] [varbinary](max) NULL,
	[Description] [varchar](250) NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_AssetReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[AssetReport]  WITH CHECK ADD  CONSTRAINT [FK_AssetReport_Asset] FOREIGN KEY([IdAsset])
REFERENCES [dbo].[Asset] ([Id])
ALTER TABLE [dbo].[AssetReport] CHECK CONSTRAINT [FK_AssetReport_Asset]
ALTER TABLE [dbo].[AssetReport]  WITH CHECK ADD  CONSTRAINT [FK_AssetReport_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[AssetReport] CHECK CONSTRAINT [FK_AssetReport_PersonOfInterest]
ALTER TABLE [dbo].[AssetReport]  WITH CHECK ADD  CONSTRAINT [FK_AssetReport_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[AssetReport] CHECK CONSTRAINT [FK_AssetReport_PointOfInterest]
