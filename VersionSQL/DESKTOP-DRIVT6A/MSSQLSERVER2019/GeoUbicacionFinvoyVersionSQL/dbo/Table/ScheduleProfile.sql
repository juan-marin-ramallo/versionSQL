/****** Object:  Table [dbo].[ScheduleProfile]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleProfile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[Description] [varchar](200) NULL,
	[AllPersonOfInterest] [bit] NULL,
	[AllPointOfInterest] [bit] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IdUser] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[LimitOneMissingReport] [bit] NOT NULL,
	[RecurrenceCondition] [char](1) NOT NULL,
	[RecurrenceNumber] [int] NOT NULL,
	[IdScheduleProfileCron] [int] NOT NULL,
 CONSTRAINT [PK_ScheduleProfile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleProfile] ADD  CONSTRAINT [DF_ScheduleProfile_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[ScheduleProfile] ADD  CONSTRAINT [DF_ScheduleProfile_LimitOneMissingReport]  DEFAULT ((0)) FOR [LimitOneMissingReport]
ALTER TABLE [dbo].[ScheduleProfile] ADD  CONSTRAINT [DF__ScheduleP__Recur__24E90E71]  DEFAULT ('D') FOR [RecurrenceCondition]
ALTER TABLE [dbo].[ScheduleProfile] ADD  CONSTRAINT [DF__ScheduleP__Recur__25DD32AA]  DEFAULT ((1)) FOR [RecurrenceNumber]
ALTER TABLE [dbo].[ScheduleProfile] ADD  DEFAULT ((1)) FOR [IdScheduleProfileCron]
ALTER TABLE [dbo].[ScheduleProfile]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProfile_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[ScheduleProfile] CHECK CONSTRAINT [FK_ScheduleProfile_User]
