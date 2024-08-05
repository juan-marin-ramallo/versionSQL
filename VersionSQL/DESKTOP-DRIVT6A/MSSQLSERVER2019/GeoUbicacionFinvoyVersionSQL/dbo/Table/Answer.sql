/****** Object:  Table [dbo].[Answer]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Answer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdQuestion] [int] NOT NULL,
	[IdCompletedForm] [int] NOT NULL,
	[QuestionType] [varchar](5) NOT NULL,
	[FreeText] [varchar](5000) NULL,
	[Check] [bit] NULL,
	[YNOption] [bit] NULL,
	[DateReply] [datetime] NULL,
	[ImageName] [varchar](100) NULL,
	[ImageEncoded] [varbinary](max) NULL,
	[Skipped] [bit] NOT NULL,
	[IdQuestionOption] [int] NULL,
	[ImageUrl] [varchar](5000) NULL,
	[DoesNotApply] [bit] NULL,
	[test] [int] NULL,
 CONSTRAINT [PK_Answer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Answer] ADD  CONSTRAINT [DF_Answer_DoesNotApply]  DEFAULT ((0)) FOR [DoesNotApply]
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answer_CompletedForm] FOREIGN KEY([IdCompletedForm])
REFERENCES [dbo].[CompletedForm] ([Id])
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answer_CompletedForm]
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answer_Question] FOREIGN KEY([IdQuestion])
REFERENCES [dbo].[Question] ([Id])
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answer_Question]
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answer_QuestionOption] FOREIGN KEY([IdQuestionOption])
REFERENCES [dbo].[QuestionOption] ([Id])
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answer_QuestionOption]
