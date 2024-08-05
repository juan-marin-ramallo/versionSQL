/****** Object:  Table [dbo].[Catalog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Catalog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Catalog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Catalog] ADD  CONSTRAINT [DF_Catalog_Deleted]  DEFAULT ((0)) FOR [Deleted]
