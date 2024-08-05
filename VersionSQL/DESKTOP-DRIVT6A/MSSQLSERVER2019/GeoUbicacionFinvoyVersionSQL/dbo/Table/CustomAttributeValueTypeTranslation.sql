/****** Object:  Table [dbo].[CustomAttributeValueTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomAttributeValueTypeTranslation](
	[CodeCustomAttributeValueType] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CustomAttributeValueTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[CodeCustomAttributeValueType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomAttributeValueTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttributeValueTypeTranslation_CustomAttributeValueType] FOREIGN KEY([CodeCustomAttributeValueType])
REFERENCES [dbo].[CustomAttributeValueType] ([Code])
ALTER TABLE [dbo].[CustomAttributeValueTypeTranslation] CHECK CONSTRAINT [FK_CustomAttributeValueTypeTranslation_CustomAttributeValueType]
ALTER TABLE [dbo].[CustomAttributeValueTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttributeValueTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[CustomAttributeValueTypeTranslation] CHECK CONSTRAINT [FK_CustomAttributeValueTypeTranslation_Language]
