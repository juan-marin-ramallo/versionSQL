/****** Object:  Table [dbo].[AnswerTag]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AnswerTag](
	[IdAnswer] [int] NOT NULL,
	[IdTag] [int] NOT NULL,
 CONSTRAINT [PK_AnswerTag] PRIMARY KEY CLUSTERED 
(
	[IdAnswer] ASC,
	[IdTag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AnswerTag]  WITH CHECK ADD  CONSTRAINT [FK_AnswerTag_Answer] FOREIGN KEY([IdAnswer])
REFERENCES [dbo].[Answer] ([Id])
ALTER TABLE [dbo].[AnswerTag] CHECK CONSTRAINT [FK_AnswerTag_Answer]
ALTER TABLE [dbo].[AnswerTag]  WITH CHECK ADD  CONSTRAINT [FK_AnswerTag_Parameter] FOREIGN KEY([IdTag])
REFERENCES [dbo].[Parameter] ([Id])
ALTER TABLE [dbo].[AnswerTag] CHECK CONSTRAINT [FK_AnswerTag_Parameter]
