/****** Object:  Table [dbo].[AssetType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssetType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Description] [varchar](250) NULL,
	[Deleted] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[EditedDate] [datetime] NULL,
	[IdUser] [int] NULL,
 CONSTRAINT [PK_AssetType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AssetType] ADD  CONSTRAINT [DF_AssetType_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[AssetType]  WITH CHECK ADD  CONSTRAINT [FK_AssetType_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[AssetType] CHECK CONSTRAINT [FK_AssetType_User]
