/****** Object:  Table [dbo].[DateRangeTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DateRangeTranslation](
	[IdDateRange] [smallint] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](128) NOT NULL,
 CONSTRAINT [PK_DateRangeTranslation] PRIMARY KEY CLUSTERED 
(
	[IdDateRange] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DateRangeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_DateRangeTranslation_DateRange] FOREIGN KEY([IdDateRange])
REFERENCES [dbo].[DateRange] ([Id])
ALTER TABLE [dbo].[DateRangeTranslation] CHECK CONSTRAINT [FK_DateRangeTranslation_DateRange]
ALTER TABLE [dbo].[DateRangeTranslation]  WITH CHECK ADD  CONSTRAINT [FK_DateRangeTranslation_DateRangeTranslation] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[DateRangeTranslation] CHECK CONSTRAINT [FK_DateRangeTranslation_DateRangeTranslation]
