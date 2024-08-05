/****** Object:  Table [dbo].[CommonTextTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CommonTextTranslation](
	[IdCommonText] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Text] [varchar](5000) NOT NULL,
 CONSTRAINT [PK_CommonTextTranslation] PRIMARY KEY CLUSTERED 
(
	[IdCommonText] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CommonTextTranslation]  WITH CHECK ADD  CONSTRAINT [FK_CommonTextTranslation_CommonText] FOREIGN KEY([IdCommonText])
REFERENCES [dbo].[CommonText] ([Id])
ALTER TABLE [dbo].[CommonTextTranslation] CHECK CONSTRAINT [FK_CommonTextTranslation_CommonText]
ALTER TABLE [dbo].[CommonTextTranslation]  WITH CHECK ADD  CONSTRAINT [FK_CommonTextTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[CommonTextTranslation] CHECK CONSTRAINT [FK_CommonTextTranslation_Language]
