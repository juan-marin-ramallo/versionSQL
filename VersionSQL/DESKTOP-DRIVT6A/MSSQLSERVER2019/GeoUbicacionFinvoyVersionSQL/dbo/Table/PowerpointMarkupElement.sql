/****** Object:  Table [dbo].[PowerpointMarkupElement]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PowerpointMarkupElement](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPowerPointMarkup] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[X] [smallint] NOT NULL,
	[Y] [smallint] NOT NULL,
	[Cx] [smallint] NOT NULL,
	[Cy] [smallint] NOT NULL,
 CONSTRAINT [PK_PowerpointMarkupElement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PowerpointMarkupElement]  WITH CHECK ADD  CONSTRAINT [FK_PowerpointMarkupElement_PowerpointMarkup] FOREIGN KEY([IdPowerPointMarkup])
REFERENCES [dbo].[PowerpointMarkup] ([Id])
ALTER TABLE [dbo].[PowerpointMarkupElement] CHECK CONSTRAINT [FK_PowerpointMarkupElement_PowerpointMarkup]
