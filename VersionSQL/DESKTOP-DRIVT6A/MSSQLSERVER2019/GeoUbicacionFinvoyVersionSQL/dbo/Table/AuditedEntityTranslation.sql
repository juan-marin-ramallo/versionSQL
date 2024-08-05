/****** Object:  Table [dbo].[AuditedEntityTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AuditedEntityTranslation](
	[IdAuditedEntity] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_AuditedEntityTranslation] PRIMARY KEY CLUSTERED 
(
	[IdAuditedEntity] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AuditedEntityTranslation]  WITH CHECK ADD  CONSTRAINT [FK_AuditedEntityTranslation_AuditedEntity] FOREIGN KEY([IdAuditedEntity])
REFERENCES [dbo].[AuditedEntity] ([Id])
ALTER TABLE [dbo].[AuditedEntityTranslation] CHECK CONSTRAINT [FK_AuditedEntityTranslation_AuditedEntity]
ALTER TABLE [dbo].[AuditedEntityTranslation]  WITH CHECK ADD  CONSTRAINT [FK_AuditedEntityTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[AuditedEntityTranslation] CHECK CONSTRAINT [FK_AuditedEntityTranslation_Language]
