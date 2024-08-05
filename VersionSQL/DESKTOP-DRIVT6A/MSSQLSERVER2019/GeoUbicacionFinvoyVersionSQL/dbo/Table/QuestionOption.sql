/****** Object:  Table [dbo].[QuestionOption]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[QuestionOption](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdQuestion] [int] NOT NULL,
	[Text] [varchar](250) NOT NULL,
	[Default] [bit] NOT NULL,
	[Weight] [int] NULL,
	[IsNotApply] [bit] NULL,
	[RedirectToSection] [int] NULL,
 CONSTRAINT [PK_QuestionOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[QuestionOption]  WITH CHECK ADD  CONSTRAINT [FK_QuestionOption_Question] FOREIGN KEY([IdQuestion])
REFERENCES [dbo].[Question] ([Id])
ALTER TABLE [dbo].[QuestionOption] CHECK CONSTRAINT [FK_QuestionOption_Question]
