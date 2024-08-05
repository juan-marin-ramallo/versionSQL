/****** Object:  Table [dbo].[RouteDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[RouteDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RouteDate] [datetime] NOT NULL,
	[IdRoutePointOfInterest] [int] NULL,
	[Disabled] [bit] NULL,
	[NoVisited] [bit] NULL,
	[IdRouteNoVisitOption] [int] NULL,
	[DateNoVisited] [datetime] NULL,
	[NoVisitedApprovedState] [smallint] NOT NULL,
	[IdUserNoVisitedApproved] [int] NULL,
	[NoVisitedApprovedComment] [varchar](1024) NULL,
	[NoVisitedApprovedDate] [datetime] NULL,
	[FromHour] [time](7) NULL,
	[ToHour] [time](7) NULL,
	[Title] [varchar](250) NULL,
	[WebNoVisitComment] [varchar](1000) NULL,
	[IdUserWebNoVisitComment] [int] NULL,
	[WebNoVisitCommentDate] [datetime] NULL,
	[TheoricalMinutes] [int] NULL,
	[DisabledType] [smallint] NULL,
	[IsPriority] [bit] NOT NULL,
 CONSTRAINT [PK_RouteDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_RouteDetail_Disabled_NoVisited] ON [dbo].[RouteDetail]
(
	[Disabled] ASC,
	[NoVisited] ASC
)
INCLUDE([RouteDate],[IdRoutePointOfInterest],[NoVisitedApprovedState]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_RouteDetail_Disabled] ON [dbo].[RouteDetail]
(
	[Disabled] ASC
)
INCLUDE([Id],[IdRoutePointOfInterest],[NoVisited],[RouteDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_RouteDetail_IdRoutePointOfInterest_Disabled] ON [dbo].[RouteDetail]
(
	[IdRoutePointOfInterest] ASC,
	[Disabled] ASC
)
INCLUDE([Id],[NoVisited],[RouteDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[RouteDetail] ADD  CONSTRAINT [DF_RouteDetail_NoVisitedAproved]  DEFAULT ((0)) FOR [NoVisitedApprovedState]
ALTER TABLE [dbo].[RouteDetail] ADD  CONSTRAINT [DF_RouteDetail_IsPriority]  DEFAULT ((0)) FOR [IsPriority]
ALTER TABLE [dbo].[RouteDetail]  WITH CHECK ADD  CONSTRAINT [FK_RouteDetail_Route] FOREIGN KEY([IdRoutePointOfInterest])
REFERENCES [dbo].[RoutePointOfInterest] ([Id])
ALTER TABLE [dbo].[RouteDetail] CHECK CONSTRAINT [FK_RouteDetail_Route]
ALTER TABLE [dbo].[RouteDetail]  WITH CHECK ADD  CONSTRAINT [FK_RouteDetail_RouteDetailDisabledType] FOREIGN KEY([DisabledType])
REFERENCES [dbo].[RouteDetailDisabledType] ([Id])
ALTER TABLE [dbo].[RouteDetail] CHECK CONSTRAINT [FK_RouteDetail_RouteDetailDisabledType]
ALTER TABLE [dbo].[RouteDetail]  WITH CHECK ADD  CONSTRAINT [FK_RouteDetail_RouteNoVisitOption] FOREIGN KEY([IdRouteNoVisitOption])
REFERENCES [dbo].[RouteNoVisitOption] ([Id])
ALTER TABLE [dbo].[RouteDetail] CHECK CONSTRAINT [FK_RouteDetail_RouteNoVisitOption]
ALTER TABLE [dbo].[RouteDetail]  WITH CHECK ADD  CONSTRAINT [FK_RouteDetail_User] FOREIGN KEY([IdUserNoVisitedApproved])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[RouteDetail] CHECK CONSTRAINT [FK_RouteDetail_User]
