/****** Object:  Table [dbo].[Dynamic]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Dynamic](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdFormPlus] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Disabled] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[AllPersonOfInterest] [bit] NOT NULL,
	[IdUser] [int] NOT NULL,
 CONSTRAINT [PK_Dynamic] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Dynamic] ADD  CONSTRAINT [DF__Dynamic__AllPers__4773309F]  DEFAULT ((0)) FOR [AllPersonOfInterest]
ALTER TABLE [dbo].[Dynamic] ADD  CONSTRAINT [DF__Dynamic__IdUser__6BB09115]  DEFAULT ((1)) FOR [IdUser]
ALTER TABLE [dbo].[Dynamic]  WITH CHECK ADD  CONSTRAINT [FK_Dynamic_FormPlus] FOREIGN KEY([IdFormPlus])
REFERENCES [dbo].[FormPlus] ([Id])
ALTER TABLE [dbo].[Dynamic] CHECK CONSTRAINT [FK_Dynamic_FormPlus]
