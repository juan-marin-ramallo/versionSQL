/****** Object:  Table [dbo].[AvailableFileTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AvailableFileTypeTranslation](
	[IdAvailableFileType] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[FileType] [varchar](20) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_AvailableFileTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[IdAvailableFileType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AvailableFileTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_AvailableFileTypeTranslation_AvailableFileType] FOREIGN KEY([IdAvailableFileType])
REFERENCES [dbo].[AvailableFileType] ([Id])
ALTER TABLE [dbo].[AvailableFileTypeTranslation] CHECK CONSTRAINT [FK_AvailableFileTypeTranslation_AvailableFileType]
ALTER TABLE [dbo].[AvailableFileTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_AvailableFileTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[AvailableFileTypeTranslation] CHECK CONSTRAINT [FK_AvailableFileTypeTranslation_Language]
