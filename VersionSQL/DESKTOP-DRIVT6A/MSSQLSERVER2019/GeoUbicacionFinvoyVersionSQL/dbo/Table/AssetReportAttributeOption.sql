/****** Object:  Table [dbo].[AssetReportAttributeOption]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssetReportAttributeOption](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdAssetReportAttribute] [int] NOT NULL,
	[Text] [varchar](100) NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_AssetReportAttributeOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AssetReportAttributeOption]  WITH CHECK ADD  CONSTRAINT [FK_AssetReportAttributeOption_AssetReportAttribute] FOREIGN KEY([IdAssetReportAttribute])
REFERENCES [dbo].[AssetReportAttribute] ([Id])
ALTER TABLE [dbo].[AssetReportAttributeOption] CHECK CONSTRAINT [FK_AssetReportAttributeOption_AssetReportAttribute]
