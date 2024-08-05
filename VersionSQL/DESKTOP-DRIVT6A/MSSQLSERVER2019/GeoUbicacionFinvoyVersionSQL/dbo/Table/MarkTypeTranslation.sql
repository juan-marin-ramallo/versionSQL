/****** Object:  Table [dbo].[MarkTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MarkTypeTranslation](
	[CodeMarkType] [varchar](5) NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_MarkTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[CodeMarkType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MarkTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_MarkTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[MarkTypeTranslation] CHECK CONSTRAINT [FK_MarkTypeTranslation_Language]
ALTER TABLE [dbo].[MarkTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_MarkTypeTranslation_MarkType] FOREIGN KEY([CodeMarkType])
REFERENCES [dbo].[MarkType] ([Code])
ALTER TABLE [dbo].[MarkTypeTranslation] CHECK CONSTRAINT [FK_MarkTypeTranslation_MarkType]
