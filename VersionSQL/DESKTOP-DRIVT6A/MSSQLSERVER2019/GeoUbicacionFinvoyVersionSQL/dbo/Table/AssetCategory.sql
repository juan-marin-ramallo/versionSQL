/****** Object:  Table [dbo].[AssetCategory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssetCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Identifier] [varchar](50) NULL,
	[IsSubCategory] [bit] NULL,
	[IdCategoryFather] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[IdUser] [int] NULL,
	[Deleted] [bit] NULL,
 CONSTRAINT [PK_AssetCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AssetCategory] ADD  CONSTRAINT [DF_AssetCategory_IsSubCategory]  DEFAULT ((0)) FOR [IsSubCategory]
ALTER TABLE [dbo].[AssetCategory] ADD  CONSTRAINT [DF_AssetCategory_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[AssetCategory]  WITH CHECK ADD  CONSTRAINT [FK_AssetCategory_AssetCategory] FOREIGN KEY([IdCategoryFather])
REFERENCES [dbo].[AssetCategory] ([Id])
ALTER TABLE [dbo].[AssetCategory] CHECK CONSTRAINT [FK_AssetCategory_AssetCategory]
ALTER TABLE [dbo].[AssetCategory]  WITH CHECK ADD  CONSTRAINT [FK_AssetCategory_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[AssetCategory] CHECK CONSTRAINT [FK_AssetCategory_User]
