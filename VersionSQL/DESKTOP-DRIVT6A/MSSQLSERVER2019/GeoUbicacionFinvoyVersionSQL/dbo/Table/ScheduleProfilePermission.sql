/****** Object:  Table [dbo].[ScheduleProfilePermission]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleProfilePermission](
	[IdScheduleProfile] [int] NOT NULL,
	[IdPersonOfInterestPermission] [int] NOT NULL,
	[LimitOnlyOnce] [bit] NOT NULL,
 CONSTRAINT [PK_ScheduleProfilePermission] PRIMARY KEY CLUSTERED 
(
	[IdScheduleProfile] ASC,
	[IdPersonOfInterestPermission] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleProfilePermission] ADD  CONSTRAINT [DF_ScheduleProfilePermission_LimitOnlyOnce]  DEFAULT ((0)) FOR [LimitOnlyOnce]
ALTER TABLE [dbo].[ScheduleProfilePermission]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfilePermission_PersonOfInterestPermission] FOREIGN KEY([IdPersonOfInterestPermission])
REFERENCES [dbo].[PersonOfInterestPermission] ([Id])
ALTER TABLE [dbo].[ScheduleProfilePermission] CHECK CONSTRAINT [FK_ScheduleProfilePermission_PersonOfInterestPermission]
ALTER TABLE [dbo].[ScheduleProfilePermission]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfilePermission_ScheduleProfile] FOREIGN KEY([IdScheduleProfile])
REFERENCES [dbo].[ScheduleProfile] ([Id])
ALTER TABLE [dbo].[ScheduleProfilePermission] CHECK CONSTRAINT [FK_ScheduleProfilePermission_ScheduleProfile]
