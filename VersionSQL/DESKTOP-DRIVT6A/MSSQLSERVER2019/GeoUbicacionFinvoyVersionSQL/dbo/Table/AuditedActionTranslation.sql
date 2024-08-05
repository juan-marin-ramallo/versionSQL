/****** Object:  Table [dbo].[AuditedActionTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AuditedActionTranslation](
	[IdAuditedAction] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_AuditedActionTranslation] PRIMARY KEY CLUSTERED 
(
	[IdAuditedAction] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AuditedActionTranslation]  WITH CHECK ADD  CONSTRAINT [FK_AuditedActionTranslation_AuditedAction] FOREIGN KEY([IdAuditedAction])
REFERENCES [dbo].[AuditedAction] ([Id])
ALTER TABLE [dbo].[AuditedActionTranslation] CHECK CONSTRAINT [FK_AuditedActionTranslation_AuditedAction]
ALTER TABLE [dbo].[AuditedActionTranslation]  WITH CHECK ADD  CONSTRAINT [FK_AuditedActionTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[AuditedActionTranslation] CHECK CONSTRAINT [FK_AuditedActionTranslation_Language]
