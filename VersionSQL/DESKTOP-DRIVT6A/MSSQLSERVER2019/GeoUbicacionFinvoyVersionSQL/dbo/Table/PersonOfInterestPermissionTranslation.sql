/****** Object:  Table [dbo].[PersonOfInterestPermissionTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterestPermissionTranslation](
	[IdPersonOfInterestPermission] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](128) NOT NULL,
	[PermissionSet] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_PersonOfInterestPermissionTranslation] PRIMARY KEY CLUSTERED 
(
	[IdPersonOfInterestPermission] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PersonOfInterestPermissionTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestPermissionTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[PersonOfInterestPermissionTranslation] CHECK CONSTRAINT [FK_PersonOfInterestPermissionTranslation_Language]
ALTER TABLE [dbo].[PersonOfInterestPermissionTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestPermissionTranslation_PersonOfInterestPermission] FOREIGN KEY([IdPersonOfInterestPermission])
REFERENCES [dbo].[PersonOfInterestPermission] ([Id])
ALTER TABLE [dbo].[PersonOfInterestPermissionTranslation] CHECK CONSTRAINT [FK_PersonOfInterestPermissionTranslation_PersonOfInterestPermission]
