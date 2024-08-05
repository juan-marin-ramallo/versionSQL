/****** Object:  Table [dbo].[ScheduleProfileCatalogDayOfWeek]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleProfileCatalogDayOfWeek](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdScheduleProfileCatalog] [int] NOT NULL,
	[DayOfWeek] [int] NOT NULL,
 CONSTRAINT [PK_ScheduleProfileCatalogDayOfWeek] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleProfileCatalogDayOfWeek]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfileCatalogDayOfWeek_ScheduleProfileCatalog] FOREIGN KEY([IdScheduleProfileCatalog])
REFERENCES [dbo].[ScheduleProfileCatalog] ([Id])
ALTER TABLE [dbo].[ScheduleProfileCatalogDayOfWeek] CHECK CONSTRAINT [FK_ScheduleProfileCatalogDayOfWeek_ScheduleProfileCatalog]
