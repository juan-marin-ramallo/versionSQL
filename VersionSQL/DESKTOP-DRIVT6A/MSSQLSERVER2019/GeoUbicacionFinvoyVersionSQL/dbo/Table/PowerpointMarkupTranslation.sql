/****** Object:  Table [dbo].[PowerpointMarkupTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PowerpointMarkupTranslation](
	[IdPowerpointMarkup] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_PowerpointMarkupTranslation] PRIMARY KEY CLUSTERED 
(
	[IdPowerpointMarkup] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PowerpointMarkupTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PowerpointMarkupTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[PowerpointMarkupTranslation] CHECK CONSTRAINT [FK_PowerpointMarkupTranslation_Language]
ALTER TABLE [dbo].[PowerpointMarkupTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PowerpointMarkupTranslation_PowerpointMarkup] FOREIGN KEY([IdPowerpointMarkup])
REFERENCES [dbo].[PowerpointMarkup] ([Id])
ALTER TABLE [dbo].[PowerpointMarkupTranslation] CHECK CONSTRAINT [FK_PowerpointMarkupTranslation_PowerpointMarkup]
