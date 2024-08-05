/****** Object:  Table [dbo].[ScheduleProfileAssignation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleProfileAssignation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPointOfInterest] [int] NULL,
	[IdPersonOfInterest] [int] NULL,
	[IdScheduleProfile] [int] NOT NULL,
 CONSTRAINT [PK_ScheduleProfileAssignation_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleProfileAssignation]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfileAssignation_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[ScheduleProfileAssignation] CHECK CONSTRAINT [FK_ScheduleProfileAssignation_PersonOfInterest]
ALTER TABLE [dbo].[ScheduleProfileAssignation]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfileAssignation_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[ScheduleProfileAssignation] CHECK CONSTRAINT [FK_ScheduleProfileAssignation_PointOfInterest]
ALTER TABLE [dbo].[ScheduleProfileAssignation]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfileAssignation_ScheduleProfile] FOREIGN KEY([IdScheduleProfile])
REFERENCES [dbo].[ScheduleProfile] ([Id])
ALTER TABLE [dbo].[ScheduleProfileAssignation] CHECK CONSTRAINT [FK_ScheduleProfileAssignation_ScheduleProfile]
