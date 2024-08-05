/****** Object:  Table [dbo].[SynchronizationTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[SynchronizationTypeTranslation](
	[CodeSynchronizationType] [smallint] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Text] [varchar](128) NOT NULL,
 CONSTRAINT [PK_SynchronizationTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[CodeSynchronizationType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SynchronizationTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_SynchronizationTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[SynchronizationTypeTranslation] CHECK CONSTRAINT [FK_SynchronizationTypeTranslation_Language]
ALTER TABLE [dbo].[SynchronizationTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_SynchronizationTypeTranslation_SynchronizationType] FOREIGN KEY([CodeSynchronizationType])
REFERENCES [dbo].[SynchronizationType] ([Code])
ALTER TABLE [dbo].[SynchronizationTypeTranslation] CHECK CONSTRAINT [FK_SynchronizationTypeTranslation_SynchronizationType]
