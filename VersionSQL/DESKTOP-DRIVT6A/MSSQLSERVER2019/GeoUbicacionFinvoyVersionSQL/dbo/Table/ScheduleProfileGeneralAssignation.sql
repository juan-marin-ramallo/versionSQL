/****** Object:  Table [dbo].[ScheduleProfileGeneralAssignation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleProfileGeneralAssignation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdScheduleProfile] [int] NULL,
	[IdPersonOfInterestType] [char](1) NULL,
 CONSTRAINT [PK_ScheduleProfileGeneralAssignation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleProfileGeneralAssignation]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfileGeneralAssignation_PersonOfInterestType] FOREIGN KEY([IdPersonOfInterestType])
REFERENCES [dbo].[PersonOfInterestType] ([Code])
ALTER TABLE [dbo].[ScheduleProfileGeneralAssignation] CHECK CONSTRAINT [FK_ScheduleProfileGeneralAssignation_PersonOfInterestType]
ALTER TABLE [dbo].[ScheduleProfileGeneralAssignation]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfileGeneralAssignation_ScheduleProfile] FOREIGN KEY([IdScheduleProfile])
REFERENCES [dbo].[ScheduleProfile] ([Id])
ALTER TABLE [dbo].[ScheduleProfileGeneralAssignation] CHECK CONSTRAINT [FK_ScheduleProfileGeneralAssignation_ScheduleProfile]
