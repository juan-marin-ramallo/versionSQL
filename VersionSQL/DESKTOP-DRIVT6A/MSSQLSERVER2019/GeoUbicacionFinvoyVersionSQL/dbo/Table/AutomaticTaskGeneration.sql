/****** Object:  Table [dbo].[AutomaticTaskGeneration]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AutomaticTaskGeneration](
	[Code] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IdConfiguration] [int] NOT NULL,
	[IdPermission] [smallint] NULL,
	[TimeValue] [varchar](50) NULL,
 CONSTRAINT [PK_AutomaticTaskGeneration] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AutomaticTaskGeneration]  WITH CHECK ADD  CONSTRAINT [FK_AutomaticTaskGeneration_Configuration] FOREIGN KEY([IdConfiguration])
REFERENCES [dbo].[Configuration] ([Id])
ALTER TABLE [dbo].[AutomaticTaskGeneration] CHECK CONSTRAINT [FK_AutomaticTaskGeneration_Configuration]
ALTER TABLE [dbo].[AutomaticTaskGeneration]  WITH CHECK ADD  CONSTRAINT [FK_AutomaticTaskGeneration_Permission] FOREIGN KEY([IdPermission])
REFERENCES [dbo].[Permission] ([Id])
ALTER TABLE [dbo].[AutomaticTaskGeneration] CHECK CONSTRAINT [FK_AutomaticTaskGeneration_Permission]
