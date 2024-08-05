/****** Object:  Table [dbo].[PointOfInterestVisited]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PointOfInterestVisited](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdLocationIn] [int] NOT NULL,
	[LocationInDate] [datetime] NOT NULL,
	[IdLocationOut] [int] NULL,
	[LocationOutDate] [datetime] NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[ElapsedTime] [time](7) NULL,
	[ClosedByChangeOfDay] [bit] NOT NULL,
	[DeletedByNotVisited] [bit] NOT NULL,
	[LatitudeIn] [decimal](25, 20) NULL,
	[LongitudeIn] [decimal](25, 20) NULL,
	[InHourWindow] [bit] NOT NULL,
 CONSTRAINT [PK_PointOfInterestVisited] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_DeletedByNotVisited] ON [dbo].[PointOfInterestVisited]
(
	[DeletedByNotVisited] ASC
)
INCLUDE([ElapsedTime],[Id],[IdPersonOfInterest],[IdPointOfInterest],[LocationInDate],[LocationOutDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_PointOfInterestVisited_IdPersonOfInterest] ON [dbo].[PointOfInterestVisited]
(
	[IdPersonOfInterest] ASC
)
INCLUDE([LocationInDate],[LocationOutDate],[IdPointOfInterest],[ElapsedTime],[InHourWindow]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_PointOfInterestVisited_IdPersonOfInterest] ON [dbo].[PointOfInterestVisited]
(
	[IdPersonOfInterest] ASC
)
INCLUDE([IdPointOfInterest],[LocationOutDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_PointOfInterestVisited_IdPersonOfInterest_2] ON [dbo].[PointOfInterestVisited]
(
	[IdPersonOfInterest] ASC
)
INCLUDE([IdPointOfInterest],[LocationInDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[PointOfInterestVisited] ADD  CONSTRAINT [DF_PointOfInterestVisited_ClosedByChangeOfDay]  DEFAULT ((0)) FOR [ClosedByChangeOfDay]
ALTER TABLE [dbo].[PointOfInterestVisited] ADD  CONSTRAINT [DF_PointOfInterestVisited_DeletedByNotVisited]  DEFAULT ((0)) FOR [DeletedByNotVisited]
ALTER TABLE [dbo].[PointOfInterestVisited] ADD  CONSTRAINT [DF_PointOfInterestVisited_InHourWindow]  DEFAULT ((0)) FOR [InHourWindow]
ALTER TABLE [dbo].[PointOfInterestVisited]  WITH NOCHECK ADD  CONSTRAINT [FK_PointOfInterestVisited_Location_In] FOREIGN KEY([IdLocationIn])
REFERENCES [dbo].[Location] ([Id])
ALTER TABLE [dbo].[PointOfInterestVisited] CHECK CONSTRAINT [FK_PointOfInterestVisited_Location_In]
ALTER TABLE [dbo].[PointOfInterestVisited]  WITH NOCHECK ADD  CONSTRAINT [FK_PointOfInterestVisited_Location_Out] FOREIGN KEY([IdLocationOut])
REFERENCES [dbo].[Location] ([Id])
ALTER TABLE [dbo].[PointOfInterestVisited] CHECK CONSTRAINT [FK_PointOfInterestVisited_Location_Out]
ALTER TABLE [dbo].[PointOfInterestVisited]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterestVisited_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[PointOfInterestVisited] CHECK CONSTRAINT [FK_PointOfInterestVisited_PersonOfInterest]
