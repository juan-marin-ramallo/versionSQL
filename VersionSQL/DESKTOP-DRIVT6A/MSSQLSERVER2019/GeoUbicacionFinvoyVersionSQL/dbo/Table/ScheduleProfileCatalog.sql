/****** Object:  Table [dbo].[ScheduleProfileCatalog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleProfileCatalog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdScheduleProfile] [int] NOT NULL,
	[IdCatalog] [int] NOT NULL,
	[IdScheduleProfileCatalogCron] [int] NOT NULL,
	[Comment] [varchar](250) NULL,
	[Deleted] [bit] NOT NULL,
	[RecurrenceCondition] [char](1) NULL,
	[RecurrenceNumber] [int] NULL,
 CONSTRAINT [PK_ScheduleProfileCatalog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleProfileCatalog]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfileCatalog_Catalog] FOREIGN KEY([IdCatalog])
REFERENCES [dbo].[Catalog] ([Id])
ALTER TABLE [dbo].[ScheduleProfileCatalog] CHECK CONSTRAINT [FK_ScheduleProfileCatalog_Catalog]
ALTER TABLE [dbo].[ScheduleProfileCatalog]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfileCatalog_ScheduleProfile] FOREIGN KEY([IdScheduleProfile])
REFERENCES [dbo].[ScheduleProfile] ([Id])
ALTER TABLE [dbo].[ScheduleProfileCatalog] CHECK CONSTRAINT [FK_ScheduleProfileCatalog_ScheduleProfile]
ALTER TABLE [dbo].[ScheduleProfileCatalog]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfileCatalog_ScheduleProfileCatalogCron] FOREIGN KEY([IdScheduleProfileCatalogCron])
REFERENCES [dbo].[ScheduleProfileCatalogCron] ([Id])
ALTER TABLE [dbo].[ScheduleProfileCatalog] CHECK CONSTRAINT [FK_ScheduleProfileCatalog_ScheduleProfileCatalogCron]
