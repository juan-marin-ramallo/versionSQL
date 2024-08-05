/****** Object:  Table [dbo].[RoutePointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[RoutePointOfInterest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[Comment] [varchar](500) NULL,
	[RecurrenceCondition] [char](1) NULL,
	[RecurrenceNumber] [int] NULL,
	[AlternativeRoute] [bit] NOT NULL,
	[IdRouteGroup] [int] NULL,
	[Deleted] [bit] NULL,
	[EditedDate] [datetime] NULL,
	[WebAssignment] [bit] NULL,
 CONSTRAINT [PK_RoutePointOfInterest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NCL_IX_RoutePointOfInterest_Deleted] ON [dbo].[RoutePointOfInterest]
(
	[Deleted] ASC
)
INCLUDE([AlternativeRoute],[Id],[IdPointOfInterest],[IdRouteGroup],[RecurrenceCondition]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_RoutePointOfInterest_IdRouteGroup_Deleted] ON [dbo].[RoutePointOfInterest]
(
	[IdRouteGroup] ASC,
	[Deleted] ASC
)
INCLUDE([AlternativeRoute],[Id],[IdPointOfInterest],[RecurrenceCondition]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[RoutePointOfInterest] ADD  CONSTRAINT [DF_RoutePointOfInterest_AlternativeRoute]  DEFAULT ((0)) FOR [AlternativeRoute]
ALTER TABLE [dbo].[RoutePointOfInterest] ADD  CONSTRAINT [DF_RoutePointOfInterest_WebAssignment]  DEFAULT ((1)) FOR [WebAssignment]
ALTER TABLE [dbo].[RoutePointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_RoutePointOfInterest_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[RoutePointOfInterest] CHECK CONSTRAINT [FK_RoutePointOfInterest_PointOfInterest]
ALTER TABLE [dbo].[RoutePointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_RoutePointOfInterest_RouteGroup] FOREIGN KEY([IdRouteGroup])
REFERENCES [dbo].[RouteGroup] ([Id])
ALTER TABLE [dbo].[RoutePointOfInterest] CHECK CONSTRAINT [FK_RoutePointOfInterest_RouteGroup]
