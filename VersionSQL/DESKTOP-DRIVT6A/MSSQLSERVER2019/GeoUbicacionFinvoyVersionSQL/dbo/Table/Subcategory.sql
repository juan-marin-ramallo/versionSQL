/****** Object:  Table [dbo].[Subcategory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Subcategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[SapId] [varchar](18) NOT NULL,
	[Society] [varchar](4) NULL,
	[CategoryId] [int] NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Subcategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Subcategory] ADD  CONSTRAINT [DF_Subcategory_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[Subcategory]  WITH CHECK ADD  CONSTRAINT [FK_Subcategory_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
ALTER TABLE [dbo].[Subcategory] CHECK CONSTRAINT [FK_Subcategory_Category]
