/****** Object:  Table [dbo].[ConquestImage]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ConquestImage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdConquest] [int] NOT NULL,
	[ImageName] [varchar](256) NOT NULL,
	[ImageUrl] [varchar](512) NULL,
 CONSTRAINT [PK_ConquestImage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_ConquestImage] UNIQUE NONCLUSTERED 
(
	[ImageName] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ConquestImage]  WITH CHECK ADD  CONSTRAINT [FK_ConquestImage_Conquest] FOREIGN KEY([IdConquest])
REFERENCES [dbo].[Conquest] ([Id])
ALTER TABLE [dbo].[ConquestImage] CHECK CONSTRAINT [FK_ConquestImage_Conquest]
