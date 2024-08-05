/****** Object:  Table [dbo].[QuestionTag]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[QuestionTag](
	[IdQuestion] [int] NOT NULL,
	[IdTag] [int] NOT NULL,
 CONSTRAINT [PK_QuestionTag] PRIMARY KEY CLUSTERED 
(
	[IdQuestion] ASC,
	[IdTag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[QuestionTag]  WITH CHECK ADD  CONSTRAINT [FK_QuestionTag_Parameter] FOREIGN KEY([IdTag])
REFERENCES [dbo].[Parameter] ([Id])
ALTER TABLE [dbo].[QuestionTag] CHECK CONSTRAINT [FK_QuestionTag_Parameter]
ALTER TABLE [dbo].[QuestionTag]  WITH CHECK ADD  CONSTRAINT [FK_QuestionTag_Question] FOREIGN KEY([IdQuestion])
REFERENCES [dbo].[Question] ([Id])
ALTER TABLE [dbo].[QuestionTag] CHECK CONSTRAINT [FK_QuestionTag_Question]
