/****** Object:  Table [dbo].[PointOfInterestManualVisited]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PointOfInterestManualVisited](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[CheckInDate] [datetime] NOT NULL,
	[CheckOutDate] [datetime] NULL,
	[ElapsedTime] [time](7) NULL,
	[ReceivedDate] [datetime] NULL,
	[DeletedByNotVisited] [bit] NOT NULL,
	[Edited] [bit] NULL,
	[CheckOutLatitude] [decimal](25, 20) NULL,
	[CheckOutLongitude] [decimal](25, 20) NULL,
	[CheckOutPointOfInterestId] [int] NULL,
	[CheckInImageName] [varchar](256) NULL,
	[CheckInImageUrl] [varchar](512) NULL,
	[CheckOutImageName] [varchar](256) NULL,
	[CheckOutImageUrl] [varchar](512) NULL,
	[TaskCompletition] [bit] NOT NULL,
 CONSTRAINT [PK_PointOfInterestManualVisited] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NCL_IX_PointOfInterestManualVisited_IdPersonOfInterest] ON [dbo].[PointOfInterestManualVisited]
(
	[IdPersonOfInterest] ASC
)
INCLUDE([CheckOutDate],[IdPointOfInterest]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_PointOfInterestManualVisited_IdPersonOfInterest_2] ON [dbo].[PointOfInterestManualVisited]
(
	[IdPersonOfInterest] ASC
)
INCLUDE([CheckInDate],[IdPointOfInterest]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[PointOfInterestManualVisited] ADD  CONSTRAINT [DF_PointOfInterestManualVisited_TaskCompletition]  DEFAULT ((0)) FOR [TaskCompletition]
