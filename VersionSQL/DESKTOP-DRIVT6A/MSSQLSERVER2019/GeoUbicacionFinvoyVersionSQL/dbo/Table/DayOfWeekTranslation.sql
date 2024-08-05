/****** Object:  Table [dbo].[DayOfWeekTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DayOfWeekTranslation](
	[IdDayOfWeek] [smallint] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](20) NOT NULL,
 CONSTRAINT [PK_DayOfWeekTranslation] PRIMARY KEY CLUSTERED 
(
	[IdDayOfWeek] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DayOfWeekTranslation]  WITH CHECK ADD  CONSTRAINT [FK_DayOfWeekTranslation_DayOfWeek] FOREIGN KEY([IdDayOfWeek])
REFERENCES [dbo].[DayOfWeek] ([Id])
ALTER TABLE [dbo].[DayOfWeekTranslation] CHECK CONSTRAINT [FK_DayOfWeekTranslation_DayOfWeek]
ALTER TABLE [dbo].[DayOfWeekTranslation]  WITH CHECK ADD  CONSTRAINT [FK_DayOfWeekTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[DayOfWeekTranslation] CHECK CONSTRAINT [FK_DayOfWeekTranslation_Language]
