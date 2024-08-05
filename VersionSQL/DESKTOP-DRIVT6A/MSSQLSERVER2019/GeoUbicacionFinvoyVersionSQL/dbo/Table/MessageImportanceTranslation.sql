/****** Object:  Table [dbo].[MessageImportanceTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MessageImportanceTranslation](
	[IdMessageImportance] [smallint] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_MessageImportanceTranslation] PRIMARY KEY CLUSTERED 
(
	[IdMessageImportance] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MessageImportanceTranslation]  WITH CHECK ADD  CONSTRAINT [FK_MessageImportanceTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[MessageImportanceTranslation] CHECK CONSTRAINT [FK_MessageImportanceTranslation_Language]
ALTER TABLE [dbo].[MessageImportanceTranslation]  WITH CHECK ADD  CONSTRAINT [FK_MessageImportanceTranslation_MessageImportance] FOREIGN KEY([IdMessageImportance])
REFERENCES [dbo].[MessageImportance] ([Id])
ALTER TABLE [dbo].[MessageImportanceTranslation] CHECK CONSTRAINT [FK_MessageImportanceTranslation_MessageImportance]
