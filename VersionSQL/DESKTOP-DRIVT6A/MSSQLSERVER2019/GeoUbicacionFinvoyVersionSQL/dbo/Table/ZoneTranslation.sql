/****** Object:  Table [dbo].[ZoneTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ZoneTranslation](
	[IdZone] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](100) NOT NULL,
 CONSTRAINT [PK_ZoneTranslation] PRIMARY KEY CLUSTERED 
(
	[IdZone] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ZoneTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ZoneTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[ZoneTranslation] CHECK CONSTRAINT [FK_ZoneTranslation_Language]
ALTER TABLE [dbo].[ZoneTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ZoneTranslation_Zone] FOREIGN KEY([IdZone])
REFERENCES [dbo].[Zone] ([Id])
ALTER TABLE [dbo].[ZoneTranslation] CHECK CONSTRAINT [FK_ZoneTranslation_Zone]
