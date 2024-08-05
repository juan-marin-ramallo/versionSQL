/****** Object:  Table [dbo].[Location]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Location](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[ReceivedDate] [datetime] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Latitude] [decimal](25, 20) NOT NULL,
	[Longitude] [decimal](25, 20) NOT NULL,
	[Accuracy] [decimal](8, 1) NOT NULL,
	[Processed] [bit] NOT NULL,
	[BatteryLevel] [decimal](5, 2) NULL,
	[LatLong] [geography] NOT NULL,
 CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NCL_IX_Location_IdPersonOfInterest] ON [dbo].[Location]
(
	[IdPersonOfInterest] ASC
)
INCLUDE([BatteryLevel],[Date],[Id],[Latitude],[Longitude],[Processed]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_Location_IdPersonOfInterest_Processed] ON [dbo].[Location]
(
	[IdPersonOfInterest] ASC,
	[Processed] ASC
)
INCLUDE([Accuracy],[Date],[Id],[Latitude],[Longitude]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_Location_Processed] ON [dbo].[Location]
(
	[Processed] ASC
)
INCLUDE([IdPersonOfInterest]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Location] ADD  CONSTRAINT [DF_Location_BatteryLevel]  DEFAULT ((100)) FOR [BatteryLevel]
ALTER TABLE [dbo].[Location]  WITH NOCHECK ADD  CONSTRAINT [FK_Location_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_Location_PersonOfInterest]
