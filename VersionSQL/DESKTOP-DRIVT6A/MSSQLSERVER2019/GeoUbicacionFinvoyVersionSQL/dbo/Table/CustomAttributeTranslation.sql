/****** Object:  Table [dbo].[CustomAttributeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomAttributeTranslation](
	[IdCustomAttribute] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_CustomAttributeTranslation] PRIMARY KEY CLUSTERED 
(
	[IdCustomAttribute] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomAttributeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttributeTranslation_CustomAttribute] FOREIGN KEY([IdCustomAttribute])
REFERENCES [dbo].[CustomAttribute] ([Id])
ALTER TABLE [dbo].[CustomAttributeTranslation] CHECK CONSTRAINT [FK_CustomAttributeTranslation_CustomAttribute]
ALTER TABLE [dbo].[CustomAttributeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttributeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[CustomAttributeTranslation] CHECK CONSTRAINT [FK_CustomAttributeTranslation_Language]
