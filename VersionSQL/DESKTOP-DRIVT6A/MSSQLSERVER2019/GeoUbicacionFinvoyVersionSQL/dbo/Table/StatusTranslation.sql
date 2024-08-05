/****** Object:  Table [dbo].[StatusTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[StatusTranslation](
	[CodeStatus] [char](1) NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](100) NOT NULL,
 CONSTRAINT [PK_StatusTranslation] PRIMARY KEY CLUSTERED 
(
	[CodeStatus] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[StatusTranslation]  WITH CHECK ADD  CONSTRAINT [FK_StatusTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[StatusTranslation] CHECK CONSTRAINT [FK_StatusTranslation_Language]
ALTER TABLE [dbo].[StatusTranslation]  WITH CHECK ADD  CONSTRAINT [FK_StatusTranslation_Status] FOREIGN KEY([CodeStatus])
REFERENCES [dbo].[Status] ([Code])
ALTER TABLE [dbo].[StatusTranslation] CHECK CONSTRAINT [FK_StatusTranslation_Status]
