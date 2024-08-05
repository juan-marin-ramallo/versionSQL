/****** Object:  Table [dbo].[Mark]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Mark](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[Type] [varchar](5) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Latitude] [decimal](25, 20) NOT NULL,
	[Longitude] [decimal](25, 20) NOT NULL,
	[Accuracy] [decimal](8, 1) NOT NULL,
	[ReceivedDate] [datetime] NULL,
	[IdParent] [int] NULL,
	[LatLong] [geography] NULL,
	[IdPointOfInterest] [int] NULL,
	[Edited] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[TraveledDistance] [decimal](8, 2) NULL,
	[IsOnline] [bit] NULL,
	[IdMarkValidationType] [smallint] NULL,
 CONSTRAINT [PK_Mark] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_Mark_PersonOfInterest] ON [dbo].[Mark]
(
	[IdPersonOfInterest] ASC,
	[Type] ASC
)
INCLUDE([Date]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Mark] ADD  CONSTRAINT [DF_Mark_Edited]  DEFAULT ((0)) FOR [Edited]
ALTER TABLE [dbo].[Mark] ADD  CONSTRAINT [DF_Mark_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[Mark]  WITH CHECK ADD  CONSTRAINT [FK_Mark_Mark] FOREIGN KEY([IdParent])
REFERENCES [dbo].[Mark] ([Id])
ALTER TABLE [dbo].[Mark] CHECK CONSTRAINT [FK_Mark_Mark]
ALTER TABLE [dbo].[Mark]  WITH NOCHECK ADD  CONSTRAINT [FK_Mark_MarkType] FOREIGN KEY([Type])
REFERENCES [dbo].[MarkType] ([Code])
ALTER TABLE [dbo].[Mark] CHECK CONSTRAINT [FK_Mark_MarkType]
ALTER TABLE [dbo].[Mark]  WITH CHECK ADD  CONSTRAINT [FK_Mark_MarkValidationType] FOREIGN KEY([IdMarkValidationType])
REFERENCES [dbo].[MarkValidationType] ([Id])
ALTER TABLE [dbo].[Mark] CHECK CONSTRAINT [FK_Mark_MarkValidationType]
ALTER TABLE [dbo].[Mark]  WITH CHECK ADD  CONSTRAINT [FK_Mark_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[Mark] CHECK CONSTRAINT [FK_Mark_PersonOfInterest]
ALTER TABLE [dbo].[Mark]  WITH CHECK ADD  CONSTRAINT [FK_Mark_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[Mark] CHECK CONSTRAINT [FK_Mark_PointOfInterest]
