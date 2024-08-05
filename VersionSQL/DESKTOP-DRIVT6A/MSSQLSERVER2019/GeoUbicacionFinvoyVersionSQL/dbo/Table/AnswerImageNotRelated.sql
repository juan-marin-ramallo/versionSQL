/****** Object:  Table [dbo].[AnswerImageNotRelated]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AnswerImageNotRelated](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NULL,
	[ImageName] [varchar](100) NULL,
	[ImageEncode] [varbinary](max) NULL,
	[ReceivedDate] [datetime] NULL,
	[ProductReport] [bit] NOT NULL,
	[TaskReport] [bit] NOT NULL,
	[OrderReport] [bit] NOT NULL,
 CONSTRAINT [PK_AnswerImageNotRelated] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[AnswerImageNotRelated] ADD  CONSTRAINT [DF_AnswerImageNotRelated_ProductReport]  DEFAULT ((0)) FOR [ProductReport]
ALTER TABLE [dbo].[AnswerImageNotRelated] ADD  CONSTRAINT [DF_AnswerImageNotRelated_TaskReport]  DEFAULT ((0)) FOR [TaskReport]
ALTER TABLE [dbo].[AnswerImageNotRelated] ADD  CONSTRAINT [DF_AnswerImageNotRelated_OrderReport]  DEFAULT ((0)) FOR [OrderReport]
