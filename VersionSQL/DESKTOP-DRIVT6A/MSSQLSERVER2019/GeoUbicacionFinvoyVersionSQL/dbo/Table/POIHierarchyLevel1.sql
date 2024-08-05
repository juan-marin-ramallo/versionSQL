/****** Object:  Table [dbo].[POIHierarchyLevel1]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[POIHierarchyLevel1](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[SapId] [varchar](100) NOT NULL,
	[Society] [varchar](4) NULL,
	[Deleted] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[IdUser] [int] NULL,
 CONSTRAINT [PK_Grandfather] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[POIHierarchyLevel1] ADD  CONSTRAINT [DF_Grandfather_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[POIHierarchyLevel1]  WITH CHECK ADD  CONSTRAINT [FK_Grandfather_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[POIHierarchyLevel1] CHECK CONSTRAINT [FK_Grandfather_User]
