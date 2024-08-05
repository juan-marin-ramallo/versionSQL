/****** Object:  Table [dbo].[PointOfInterestMark]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PointOfInterestMark](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[CheckInDate] [datetime] NOT NULL,
	[InReceivedDate] [datetime] NOT NULL,
	[Edited] [bit] NULL,
	[CheckOutDate] [datetime] NULL,
	[OutReceivedDate] [datetime] NULL,
	[ElapsedTime] [time](7) NULL,
	[DeletedByNotVisited] [bit] NULL,
	[Completition] [bit] NULL,
 CONSTRAINT [PK_PointOfInterestMark] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_DeletedByNotVisited_PointOfInterestMark] ON [dbo].[PointOfInterestMark]
(
	[DeletedByNotVisited] ASC
)
INCLUDE([Id],[IdPersonOfInterest],[IdPointOfInterest],[CheckInDate],[CheckOutDate],[ElapsedTime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[PointOfInterestMark]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterestMark_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[PointOfInterestMark] CHECK CONSTRAINT [FK_PointOfInterestMark_PersonOfInterest]
ALTER TABLE [dbo].[PointOfInterestMark]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterestMark_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[PointOfInterestMark] CHECK CONSTRAINT [FK_PointOfInterestMark_PointOfInterest]
