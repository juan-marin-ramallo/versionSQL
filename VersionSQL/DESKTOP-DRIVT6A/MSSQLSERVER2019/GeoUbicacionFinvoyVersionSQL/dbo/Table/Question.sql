/****** Object:  Table [dbo].[Question]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Question](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdForm] [int] NOT NULL,
	[Required] [bit] NOT NULL,
	[Text] [varchar](250) NOT NULL,
	[Type] [varchar](5) NOT NULL,
	[Hint] [varchar](150) NULL,
	[YesIsProblem] [bit] NULL,
	[NoIsProblem] [bit] NULL,
	[ImageEncoded] [varbinary](max) NULL,
	[Weight] [int] NULL,
	[IsNoWeighted] [bit] NULL,
	[DefaultAnswerText] [varchar](5000) NULL,
	[Section] [int] NOT NULL,
	[RedirectToSection] [int] NULL,
	[RedirectToSectionAlternative] [int] NULL,
 CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Question] ADD  CONSTRAINT [DF_Question_Section]  DEFAULT ((1)) FOR [Section]
ALTER TABLE [dbo].[Question]  WITH CHECK ADD  CONSTRAINT [FK_Question_Form] FOREIGN KEY([IdForm])
REFERENCES [dbo].[Form] ([Id])
ALTER TABLE [dbo].[Question] CHECK CONSTRAINT [FK_Question_Form]
ALTER TABLE [dbo].[Question]  WITH CHECK ADD  CONSTRAINT [FK_Question_QuestionType] FOREIGN KEY([Type])
REFERENCES [dbo].[QuestionType] ([Code])
ALTER TABLE [dbo].[Question] CHECK CONSTRAINT [FK_Question_QuestionType]
