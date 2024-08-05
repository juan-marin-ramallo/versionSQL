/****** Object:  Table [dbo].[PermissionTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PermissionTranslation](
	[IdPermission] [smallint] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](100) NOT NULL,
 CONSTRAINT [PK_PermissionTranslation] PRIMARY KEY CLUSTERED 
(
	[IdPermission] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PermissionTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PermissionTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[PermissionTranslation] CHECK CONSTRAINT [FK_PermissionTranslation_Language]
ALTER TABLE [dbo].[PermissionTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PermissionTranslation_Permission] FOREIGN KEY([IdPermission])
REFERENCES [dbo].[Permission] ([Id])
ALTER TABLE [dbo].[PermissionTranslation] CHECK CONSTRAINT [FK_PermissionTranslation_Permission]
