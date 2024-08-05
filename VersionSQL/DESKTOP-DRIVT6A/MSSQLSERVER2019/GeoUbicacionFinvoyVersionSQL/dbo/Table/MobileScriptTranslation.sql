/****** Object:  Table [dbo].[MobileScriptTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MobileScriptTranslation](
	[IdMobileScript] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](64) NOT NULL,
 CONSTRAINT [PK_MobileScriptTranslation] PRIMARY KEY CLUSTERED 
(
	[IdMobileScript] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MobileScriptTranslation]  WITH CHECK ADD  CONSTRAINT [FK_MobileScriptTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[MobileScriptTranslation] CHECK CONSTRAINT [FK_MobileScriptTranslation_Language]
