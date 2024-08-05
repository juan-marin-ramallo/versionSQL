/****** Object:  Table [dbo].[AssetReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssetReportAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[IdType] [int] NOT NULL,
	[DefaultValue] [varchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IdUser] [int] NULL,
	[Enabled] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Order] [int] NOT NULL,
	[Required] [bit] NOT NULL,
	[DefaultAttribute] [bit] NOT NULL,
	[IdVisibilityType] [smallint] NOT NULL,
	[CanEditRequired] [bit] NOT NULL,
	[CanEditVisibility] [bit] NOT NULL,
 CONSTRAINT [PK_AssetReportAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[AssetReportAttribute] ADD  CONSTRAINT [DF_AssetReportAttribute_Enabled]  DEFAULT ((1)) FOR [Enabled]
ALTER TABLE [dbo].[AssetReportAttribute] ADD  CONSTRAINT [DF_AssetReportAttribute_DefaultAttribute]  DEFAULT ((0)) FOR [DefaultAttribute]
ALTER TABLE [dbo].[AssetReportAttribute] ADD  CONSTRAINT [DF_AssetReportAttribute_IdVisibilityType]  DEFAULT ((1)) FOR [IdVisibilityType]
ALTER TABLE [dbo].[AssetReportAttribute] ADD  CONSTRAINT [DF_AssetReportAttribute_CanEditRequired]  DEFAULT ((1)) FOR [CanEditRequired]
ALTER TABLE [dbo].[AssetReportAttribute] ADD  CONSTRAINT [DF_AssetReportAttribute_CanEditVisibility]  DEFAULT ((1)) FOR [CanEditVisibility]
ALTER TABLE [dbo].[AssetReportAttribute]  WITH CHECK ADD  CONSTRAINT [FK_AssetReportAttribute_AssetReportAttributeType] FOREIGN KEY([IdType])
REFERENCES [dbo].[AssetReportAttributeType] ([Id])
ALTER TABLE [dbo].[AssetReportAttribute] CHECK CONSTRAINT [FK_AssetReportAttribute_AssetReportAttributeType]
ALTER TABLE [dbo].[AssetReportAttribute]  WITH CHECK ADD  CONSTRAINT [FK_AssetReportAttribute_AssetReportAttributeVisibilityType] FOREIGN KEY([IdVisibilityType])
REFERENCES [dbo].[AssetReportAttributeVisibilityType] ([Id])
ALTER TABLE [dbo].[AssetReportAttribute] CHECK CONSTRAINT [FK_AssetReportAttribute_AssetReportAttributeVisibilityType]
