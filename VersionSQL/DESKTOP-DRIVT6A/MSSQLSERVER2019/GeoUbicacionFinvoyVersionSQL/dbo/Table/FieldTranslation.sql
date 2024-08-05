/****** Object:  Table [dbo].[FieldTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[FieldTranslation](
	[IdField] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](250) NOT NULL,
	[ColumnTitle] [varchar](200) NULL,
 CONSTRAINT [PK_FieldTranslation] PRIMARY KEY CLUSTERED 
(
	[IdField] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FieldTranslation]  WITH CHECK ADD  CONSTRAINT [FK_FieldTranslation_Field] FOREIGN KEY([IdField])
REFERENCES [dbo].[Field] ([Id])
ALTER TABLE [dbo].[FieldTranslation] CHECK CONSTRAINT [FK_FieldTranslation_Field]
ALTER TABLE [dbo].[FieldTranslation]  WITH CHECK ADD  CONSTRAINT [FK_FieldTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[FieldTranslation] CHECK CONSTRAINT [FK_FieldTranslation_Language]
