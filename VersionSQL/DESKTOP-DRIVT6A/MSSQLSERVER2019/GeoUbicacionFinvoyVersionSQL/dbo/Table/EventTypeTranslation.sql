/****** Object:  Table [dbo].[EventTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[EventTypeTranslation](
	[CodeEventType] [varchar](10) NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](250) NOT NULL,
 CONSTRAINT [PK_EventTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[CodeEventType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EventTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_EventTypeTranslation_EventType] FOREIGN KEY([CodeEventType])
REFERENCES [dbo].[EventType] ([Code])
ALTER TABLE [dbo].[EventTypeTranslation] CHECK CONSTRAINT [FK_EventTypeTranslation_EventType]
ALTER TABLE [dbo].[EventTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_EventTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[EventTypeTranslation] CHECK CONSTRAINT [FK_EventTypeTranslation_Language]
