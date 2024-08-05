/****** Object:  Table [dbo].[WorkActivity]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[WorkActivity](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkPlanId] [int] NOT NULL,
	[WorkActivityTypeId] [int] NOT NULL,
	[ActivityDate] [datetime] NOT NULL,
	[ActivityEndDate] [datetime] NULL,
	[PointOfInterestId] [int] NULL,
	[RouteGroupId] [int] NULL,
	[MeetingId] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[Confirmed] [bit] NOT NULL,
	[RoutePointOfInterestId] [int] NULL,
	[MicrosoftEventId] [varchar](2048) NULL,
	[Synced] [bit] NULL,
	[SyncType] [smallint] NULL,
	[Description] [varchar](2048) NULL,
 CONSTRAINT [PK_WorkActivity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[WorkActivity] ADD  CONSTRAINT [DF_WorkActivity_MicrosoftEventId]  DEFAULT (NULL) FOR [MicrosoftEventId]
ALTER TABLE [dbo].[WorkActivity] ADD  CONSTRAINT [DF_WorkActivity_Goal]  DEFAULT (NULL) FOR [Description]
ALTER TABLE [dbo].[WorkActivity]  WITH CHECK ADD  CONSTRAINT [FK_WorkActivity_Meeting] FOREIGN KEY([MeetingId])
REFERENCES [dbo].[Meeting] ([Id])
ALTER TABLE [dbo].[WorkActivity] CHECK CONSTRAINT [FK_WorkActivity_Meeting]
ALTER TABLE [dbo].[WorkActivity]  WITH CHECK ADD  CONSTRAINT [FK_WorkActivity_RouteGroup] FOREIGN KEY([RouteGroupId])
REFERENCES [dbo].[RouteGroup] ([Id])
ALTER TABLE [dbo].[WorkActivity] CHECK CONSTRAINT [FK_WorkActivity_RouteGroup]
ALTER TABLE [dbo].[WorkActivity]  WITH CHECK ADD  CONSTRAINT [FK_WorkActivity_WorkPlan] FOREIGN KEY([WorkPlanId])
REFERENCES [dbo].[WorkPlan] ([Id])
ALTER TABLE [dbo].[WorkActivity] CHECK CONSTRAINT [FK_WorkActivity_WorkPlan]
