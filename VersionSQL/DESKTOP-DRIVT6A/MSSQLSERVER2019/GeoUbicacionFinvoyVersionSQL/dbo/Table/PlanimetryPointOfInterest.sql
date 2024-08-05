/****** Object:  Table [dbo].[PlanimetryPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PlanimetryPointOfInterest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPlanimetry] [int] NULL,
	[IdPointOfInterest] [int] NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_PlanimetryPointOfInterest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlanimetryPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_PlanimetryPointOfInterest_Planimetry] FOREIGN KEY([IdPlanimetry])
REFERENCES [dbo].[Planimetry] ([Id])
ALTER TABLE [dbo].[PlanimetryPointOfInterest] CHECK CONSTRAINT [FK_PlanimetryPointOfInterest_Planimetry]
ALTER TABLE [dbo].[PlanimetryPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_PlanimetryPointOfInterest_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[PlanimetryPointOfInterest] CHECK CONSTRAINT [FK_PlanimetryPointOfInterest_PointOfInterest]
