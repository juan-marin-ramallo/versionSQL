/****** Object:  Table [dbo].[POIHierarchyLevel2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[POIHierarchyLevel2](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[SapId] [varchar](100) NOT NULL,
	[Society] [varchar](4) NULL,
	[HierarchyLevel1Id] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[IdUser] [int] NULL,
 CONSTRAINT [PK_Father] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[POIHierarchyLevel2] ADD  CONSTRAINT [DF_Father_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[POIHierarchyLevel2]  WITH CHECK ADD  CONSTRAINT [FK_Father_Grandfather] FOREIGN KEY([HierarchyLevel1Id])
REFERENCES [dbo].[POIHierarchyLevel1] ([Id])
ALTER TABLE [dbo].[POIHierarchyLevel2] CHECK CONSTRAINT [FK_Father_Grandfather]
ALTER TABLE [dbo].[POIHierarchyLevel2]  WITH CHECK ADD  CONSTRAINT [FK_Father_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[POIHierarchyLevel2] CHECK CONSTRAINT [FK_Father_User]
