/****** Object:  Table [dbo].[Category]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[SapId] [varchar](18) NOT NULL,
	[Society] [varchar](4) NULL,
	[BrandId] [int] NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [DF_Category_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[Category]  WITH CHECK ADD  CONSTRAINT [FK_Category_Brand] FOREIGN KEY([BrandId])
REFERENCES [dbo].[Brand] ([Id])
ALTER TABLE [dbo].[Category] CHECK CONSTRAINT [FK_Category_Brand]
