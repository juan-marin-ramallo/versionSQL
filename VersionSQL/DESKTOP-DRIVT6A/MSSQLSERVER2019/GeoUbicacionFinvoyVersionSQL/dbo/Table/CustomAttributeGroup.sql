/****** Object:  Table [dbo].[CustomAttributeGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomAttributeGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IdUser] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_CustomAttributeGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomAttributeGroup] ADD  CONSTRAINT [DF_CustomAttributeGroup_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
ALTER TABLE [dbo].[CustomAttributeGroup] ADD  CONSTRAINT [DF_CustomAttributeGroup_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[CustomAttributeGroup]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttributeGroup_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[CustomAttributeGroup] CHECK CONSTRAINT [FK_CustomAttributeGroup_User]
