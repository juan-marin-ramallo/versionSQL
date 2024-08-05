/****** Object:  Table [dbo].[QuestionTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[QuestionTypeTranslation](
	[CodeQuestionType] [varchar](5) NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_QuestionTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[CodeQuestionType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[QuestionTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_QuestionTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[QuestionTypeTranslation] CHECK CONSTRAINT [FK_QuestionTypeTranslation_Language]
ALTER TABLE [dbo].[QuestionTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_QuestionTypeTranslation_QuestionType] FOREIGN KEY([CodeQuestionType])
REFERENCES [dbo].[QuestionType] ([Code])
ALTER TABLE [dbo].[QuestionTypeTranslation] CHECK CONSTRAINT [FK_QuestionTypeTranslation_QuestionType]
