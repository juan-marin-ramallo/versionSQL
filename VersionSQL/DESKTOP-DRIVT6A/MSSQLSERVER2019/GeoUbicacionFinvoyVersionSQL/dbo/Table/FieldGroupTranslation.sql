/****** Object:  Table [dbo].[FieldGroupTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[FieldGroupTranslation](
	[IdFieldGroup] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_FieldGroupTranslation] PRIMARY KEY CLUSTERED 
(
	[IdFieldGroup] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FieldGroupTranslation]  WITH CHECK ADD  CONSTRAINT [FK_FieldGroupTranslation_FieldGroup] FOREIGN KEY([IdFieldGroup])
REFERENCES [dbo].[FieldGroup] ([Id])
ALTER TABLE [dbo].[FieldGroupTranslation] CHECK CONSTRAINT [FK_FieldGroupTranslation_FieldGroup]
ALTER TABLE [dbo].[FieldGroupTranslation]  WITH CHECK ADD  CONSTRAINT [FK_FieldGroupTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[FieldGroupTranslation] CHECK CONSTRAINT [FK_FieldGroupTranslation_Language]
