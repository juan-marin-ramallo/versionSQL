/****** Object:  Table [dbo].[UserTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[UserTypeTranslation](
	[IdUserType] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](100) NOT NULL,
 CONSTRAINT [PK_UserTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[IdUserType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UserTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_UserTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[UserTypeTranslation] CHECK CONSTRAINT [FK_UserTypeTranslation_Language]
ALTER TABLE [dbo].[UserTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_UserTypeTranslation_UserType] FOREIGN KEY([IdUserType])
REFERENCES [dbo].[UserType] ([Id])
ALTER TABLE [dbo].[UserTypeTranslation] CHECK CONSTRAINT [FK_UserTypeTranslation_UserType]
