/****** Object:  Table [dbo].[PowerBIBoardTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PowerBIBoardTranslation](
	[IdPowerBIBoard] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_PowerBIBoardTranslation] PRIMARY KEY CLUSTERED 
(
	[IdPowerBIBoard] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PowerBIBoardTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PowerBIBoardTranslation_IdLanguage] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[PowerBIBoardTranslation] CHECK CONSTRAINT [FK_PowerBIBoardTranslation_IdLanguage]
ALTER TABLE [dbo].[PowerBIBoardTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PowerBIBoardTranslation_IdPowerBIBoard] FOREIGN KEY([IdPowerBIBoard])
REFERENCES [dbo].[PowerBIBoard] ([Id])
ALTER TABLE [dbo].[PowerBIBoardTranslation] CHECK CONSTRAINT [FK_PowerBIBoardTranslation_IdPowerBIBoard]
