/****** Object:  Table [dbo].[DashboardSectionTranslation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DashboardSectionTranslation](
	[IdDashboardSection] [int] NOT NULL,
	[IdLanguage] [int] NOT NULL,
	[Name] [varchar](128) NOT NULL,
	[Description] [varchar](4096) NULL,
 CONSTRAINT [PK_DashboardSectionTranslation] PRIMARY KEY CLUSTERED 
(
	[IdDashboardSection] ASC,
	[IdLanguage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DashboardSectionTranslation]  WITH CHECK ADD  CONSTRAINT [FK_DashboardSectionTranslation_DashboardSection] FOREIGN KEY([IdDashboardSection])
REFERENCES [dbo].[DashboardSection] ([Id])
ALTER TABLE [dbo].[DashboardSectionTranslation] CHECK CONSTRAINT [FK_DashboardSectionTranslation_DashboardSection]
ALTER TABLE [dbo].[DashboardSectionTranslation]  WITH CHECK ADD  CONSTRAINT [FK_DashboardSectionTranslation_Language] FOREIGN KEY([IdLanguage])
REFERENCES [dbo].[Language] ([Id])
ALTER TABLE [dbo].[DashboardSectionTranslation] CHECK CONSTRAINT [FK_DashboardSectionTranslation_Language]
