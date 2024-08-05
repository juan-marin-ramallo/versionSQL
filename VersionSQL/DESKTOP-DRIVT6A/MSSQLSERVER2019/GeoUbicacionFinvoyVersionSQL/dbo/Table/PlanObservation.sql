/****** Object:  Table [dbo].[PlanObservation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PlanObservation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdWorkPlan] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Observation] [varchar](250) NOT NULL,
 CONSTRAINT [PK_PlanObservation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlanObservation]  WITH CHECK ADD  CONSTRAINT [FK_PlanObservation_WorkPlan] FOREIGN KEY([IdWorkPlan])
REFERENCES [dbo].[WorkPlan] ([Id])
ALTER TABLE [dbo].[PlanObservation] CHECK CONSTRAINT [FK_PlanObservation_WorkPlan]
