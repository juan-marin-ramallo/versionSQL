/****** Object:  Table [dbo].[Brand]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Brand](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[SapId] [varchar](18) NOT NULL,
	[Society] [varchar](4) NULL,
	[ProviderId] [int] NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Brand] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Brand] ADD  CONSTRAINT [DF_Brand_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[Brand]  WITH CHECK ADD  CONSTRAINT [FK_Brand_Provider] FOREIGN KEY([ProviderId])
REFERENCES [dbo].[Provider] ([Id])
ALTER TABLE [dbo].[Brand] CHECK CONSTRAINT [FK_Brand_Provider]
