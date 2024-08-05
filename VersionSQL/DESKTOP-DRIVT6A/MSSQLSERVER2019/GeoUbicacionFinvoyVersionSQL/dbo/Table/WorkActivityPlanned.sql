/****** Object:  Table [dbo].[WorkActivityPlanned]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[WorkActivityPlanned](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WorkPlanId] [int] NOT NULL,
	[WorkActivityTypeId] [int] NOT NULL,
	[PlannedDate] [datetime] NOT NULL,
	[PlannedEndDate] [datetime] NULL,
	[PointOfInterestId] [int] NULL,
	[RouteGroupId] [int] NULL,
	[MeetingId] [int] NULL,
	[Completed] [bit] NOT NULL,
	[RoutePointOfInterestId] [int] NULL,
	[WorkActivityId] [int] NULL,
 CONSTRAINT [PK_WorkActivityDone] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[WorkActivityPlanned] ADD  CONSTRAINT [DF_WorkActivityPlanned_Completed]  DEFAULT ((0)) FOR [Completed]
ALTER TABLE [dbo].[WorkActivityPlanned]  WITH CHECK ADD  CONSTRAINT [FK_WorkActivityDone_WorkPlan] FOREIGN KEY([WorkPlanId])
REFERENCES [dbo].[WorkPlan] ([Id])
ALTER TABLE [dbo].[WorkActivityPlanned] CHECK CONSTRAINT [FK_WorkActivityDone_WorkPlan]
ALTER TABLE [dbo].[WorkActivityPlanned]  WITH CHECK ADD  CONSTRAINT [FK_WorkActivityPlanned_RouteGroup] FOREIGN KEY([RouteGroupId])
REFERENCES [dbo].[RouteGroup] ([Id])
ALTER TABLE [dbo].[WorkActivityPlanned] CHECK CONSTRAINT [FK_WorkActivityPlanned_RouteGroup]
