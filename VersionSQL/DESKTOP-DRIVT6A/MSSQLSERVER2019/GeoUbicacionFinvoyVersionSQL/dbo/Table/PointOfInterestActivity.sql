/****** Object:  Table [dbo].[PointOfInterestActivity]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PointOfInterestActivity](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[AutomaticValue] [smallint] NOT NULL,
	[DateIn] [datetime] NOT NULL,
	[DateOut] [datetime] NULL,
	[InHourWindow] [bit] NOT NULL,
	[ElapsedTime] [time](7) NULL,
	[ActionValue] [smallint] NULL,
	[ActionDate] [datetime] NULL,
	[IdPointOfInterestVisited] [int] NULL,
	[IdPointOfInterestManualVisited] [int] NULL,
 CONSTRAINT [PK_PointOfInterestActivity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_PointOfInterestActivity] UNIQUE NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PointOfInterestActivity]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterestActivity_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[PointOfInterestActivity] CHECK CONSTRAINT [FK_PointOfInterestActivity_PersonOfInterest]
ALTER TABLE [dbo].[PointOfInterestActivity]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterestActivity_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[PointOfInterestActivity] CHECK CONSTRAINT [FK_PointOfInterestActivity_PointOfInterest]
ALTER TABLE [dbo].[PointOfInterestActivity]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterestActivity_PointOfInterestManualActivity] FOREIGN KEY([IdPointOfInterestManualVisited])
REFERENCES [dbo].[PointOfInterestManualVisited] ([Id])
ALTER TABLE [dbo].[PointOfInterestActivity] CHECK CONSTRAINT [FK_PointOfInterestActivity_PointOfInterestManualActivity]
ALTER TABLE [dbo].[PointOfInterestActivity]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterestActivity_PointOfInterestVisited] FOREIGN KEY([IdPointOfInterestVisited])
REFERENCES [dbo].[PointOfInterestVisited] ([Id])
ALTER TABLE [dbo].[PointOfInterestActivity] CHECK CONSTRAINT [FK_PointOfInterestActivity_PointOfInterestVisited]
