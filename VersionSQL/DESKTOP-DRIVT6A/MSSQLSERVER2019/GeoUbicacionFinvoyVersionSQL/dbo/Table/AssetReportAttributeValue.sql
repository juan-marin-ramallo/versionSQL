/****** Object:  Table [dbo].[AssetReportAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssetReportAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [varchar](max) NULL,
	[IdAssetReport] [int] NOT NULL,
	[IdAssetReportAttribute] [int] NOT NULL,
	[IdAssetReportAttributeOption] [int] NULL,
	[ImageName] [varchar](100) NULL,
	[ImageUrl] [varchar](5000) NULL,
	[ImageEncoded] [varbinary](max) NULL,
 CONSTRAINT [PK_AssetReportAttributeValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[AssetReportAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_AssetReportAttributeValue_AssetReport] FOREIGN KEY([IdAssetReport])
REFERENCES [dbo].[AssetReportDynamic] ([Id])
ALTER TABLE [dbo].[AssetReportAttributeValue] CHECK CONSTRAINT [FK_AssetReportAttributeValue_AssetReport]
ALTER TABLE [dbo].[AssetReportAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_AssetReportAttributeValue_AssetReportAttribute] FOREIGN KEY([IdAssetReportAttribute])
REFERENCES [dbo].[AssetReportAttribute] ([Id])
ALTER TABLE [dbo].[AssetReportAttributeValue] CHECK CONSTRAINT [FK_AssetReportAttributeValue_AssetReportAttribute]
ALTER TABLE [dbo].[AssetReportAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_AssetReportAttributeValue_AssetReportAttributeOption] FOREIGN KEY([IdAssetReportAttributeOption])
REFERENCES [dbo].[AssetReportAttributeOption] ([Id])
ALTER TABLE [dbo].[AssetReportAttributeValue] CHECK CONSTRAINT [FK_AssetReportAttributeValue_AssetReportAttributeOption]
