/****** Object:  Table [dbo].[Asset]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Asset](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Identifier] [varchar](50) NULL,
	[BarCode] [varchar](100) NOT NULL,
	[ImageArray] [varbinary](max) NULL,
	[Deleted] [bit] NOT NULL,
	[IdAssetType] [int] NULL,
	[IdPersonOfInterest] [int] NULL,
	[Pending] [bit] NOT NULL,
	[IdCompany] [int] NULL,
	[IdCategory] [int] NULL,
	[IdSubCategory] [int] NULL,
 CONSTRAINT [PK_Asset] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Asset] ADD  CONSTRAINT [DF_Asset_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[Asset] ADD  CONSTRAINT [DF_Asset_Pending]  DEFAULT ((0)) FOR [Pending]
ALTER TABLE [dbo].[Asset]  WITH CHECK ADD  CONSTRAINT [FK_Asset_AssetCategory] FOREIGN KEY([IdCategory])
REFERENCES [dbo].[AssetCategory] ([Id])
ALTER TABLE [dbo].[Asset] CHECK CONSTRAINT [FK_Asset_AssetCategory]
ALTER TABLE [dbo].[Asset]  WITH CHECK ADD  CONSTRAINT [FK_Asset_AssetCategory1] FOREIGN KEY([IdSubCategory])
REFERENCES [dbo].[AssetCategory] ([Id])
ALTER TABLE [dbo].[Asset] CHECK CONSTRAINT [FK_Asset_AssetCategory1]
ALTER TABLE [dbo].[Asset]  WITH CHECK ADD  CONSTRAINT [FK_Asset_AssetType] FOREIGN KEY([IdAssetType])
REFERENCES [dbo].[AssetType] ([Id])
ALTER TABLE [dbo].[Asset] CHECK CONSTRAINT [FK_Asset_AssetType]
ALTER TABLE [dbo].[Asset]  WITH CHECK ADD  CONSTRAINT [FK_Asset_Company] FOREIGN KEY([IdCompany])
REFERENCES [dbo].[Company] ([Id])
ALTER TABLE [dbo].[Asset] CHECK CONSTRAINT [FK_Asset_Company]
ALTER TABLE [dbo].[Asset]  WITH CHECK ADD  CONSTRAINT [FK_Asset_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[Asset] CHECK CONSTRAINT [FK_Asset_PersonOfInterest]
