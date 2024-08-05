/****** Object:  Table [dbo].[MainBoardTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MainBoardTranslation](
	[IdMainBoard] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_MainBoardTranslation] PRIMARY KEY CLUSTERED 
(
	[IdMainBoard] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MainBoardTranslation]  WITH CHECK ADD  CONSTRAINT [FK_MainBoardTranslation_IdLanguage] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[MainBoardTranslation] CHECK CONSTRAINT [FK_MainBoardTranslation_IdLanguage]
ALTER TABLE [dbo].[MainBoardTranslation]  WITH CHECK ADD  CONSTRAINT [FK_MainBoardTranslation_IdMainBoard] FOREIGN KEY([IdMainBoard])
REFERENCES [dbo].[MainBoard] ([Id])
ALTER TABLE [dbo].[MainBoardTranslation] CHECK CONSTRAINT [FK_MainBoardTranslation_IdMainBoard]
