/****** Object:  Table [dbo].[ProductDynamicAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductDynamicAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](250) NULL,
	[EditedDate] [datetime] NULL,
	[IdUser] [int] NULL,
	[Disabled] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[IdValueType] [int] NULL,
	[ColumnName] [varchar](50) NULL,
 CONSTRAINT [PK_ProductDynamicAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductDynamicAttribute] ADD  CONSTRAINT [DF_ProductDynamicAttribute_Deleted]  DEFAULT ((0)) FOR [Disabled]
ALTER TABLE [dbo].[ProductDynamicAttribute] ADD  CONSTRAINT [DF_ProductDynamicAttribute_FullDeleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[ProductDynamicAttribute]  WITH CHECK ADD  CONSTRAINT [FK_ProductDynamicAttribute_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[ProductDynamicAttribute] CHECK CONSTRAINT [FK_ProductDynamicAttribute_User]
