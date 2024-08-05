/****** Object:  Table [dbo].[PointOfInterestMarkTypeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PointOfInterestMarkTypeTranslation](
	[CodePointOfInterestMarkType] [varchar](5) NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_PointOfInterestMarkTypeTranslation] PRIMARY KEY CLUSTERED 
(
	[CodePointOfInterestMarkType] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PointOfInterestMarkTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterestMarkTypeTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[PointOfInterestMarkTypeTranslation] CHECK CONSTRAINT [FK_PointOfInterestMarkTypeTranslation_Language]
ALTER TABLE [dbo].[PointOfInterestMarkTypeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterestMarkTypeTranslation_PointOfInterestMarkType] FOREIGN KEY([CodePointOfInterestMarkType])
REFERENCES [dbo].[PointOfInterestMarkType] ([Code])
ALTER TABLE [dbo].[PointOfInterestMarkTypeTranslation] CHECK CONSTRAINT [FK_PointOfInterestMarkTypeTranslation_PointOfInterestMarkType]
