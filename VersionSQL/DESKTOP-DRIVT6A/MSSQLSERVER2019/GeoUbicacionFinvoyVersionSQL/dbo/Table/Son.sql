/****** Object:  Table [dbo].[Son]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Son](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[SapId] [varchar](18) NOT NULL,
	[Society] [varchar](4) NULL,
	[FatherId] [int] NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Son] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Son] ADD  CONSTRAINT [DF_Son_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[Son]  WITH CHECK ADD  CONSTRAINT [FK_Son_Father] FOREIGN KEY([FatherId])
REFERENCES [dbo].[POIHierarchyLevel2] ([Id])
ALTER TABLE [dbo].[Son] CHECK CONSTRAINT [FK_Son_Father]
