/****** Object:  Table [dbo].[PointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PointOfInterest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Address] [varchar](250) NULL,
	[Identifier] [varchar](50) NULL,
	[Latitude] [decimal](25, 20) NOT NULL,
	[Longitude] [decimal](25, 20) NOT NULL,
	[LatLong] [geography] NOT NULL,
	[Radius] [int] NOT NULL,
	[MinElapsedTimeForVisit] [int] NOT NULL,
	[IdDepartment] [int] NULL,
	[NFCTagId] [varchar](20) NULL,
	[Society] [varchar](3) NULL,
	[GrandfatherId] [int] NULL,
	[FatherId] [int] NULL,
	[SonId] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[LocationChangeDate] [datetime] NULL,
	[LocationChangeUser] [int] NULL,
	[ContactName] [varchar](50) NULL,
	[ContactPhoneNumber] [varchar](50) NULL,
	[Pending] [bit] NOT NULL,
	[Image] [varbinary](max) NULL,
	[IdPersonOfInterest] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[EditedDate] [datetime] NULL,
	[ImageUrl] [varchar](2000) NULL,
	[Emails] [varchar](1000) NULL,
 CONSTRAINT [PK_PointOfInterest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [Deleted_PointOfInterest] ON [dbo].[PointOfInterest]
(
	[Deleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_PointOfInterest_Deleted] ON [dbo].[PointOfInterest]
(
	[Deleted] ASC
)
INCLUDE([Address],[Id],[Identifier],[Latitude],[LatLong],[Longitude],[Name],[NFCTagId],[Radius]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_PointOfInterest_Deleted_2] ON [dbo].[PointOfInterest]
(
	[Deleted] ASC
)
INCLUDE([Id],[IdDepartment]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_PointOfInterest_Deleted_3] ON [dbo].[PointOfInterest]
(
	[Deleted] ASC
)
INCLUDE([Address],[Id],[IdDepartment],[Latitude],[LatLong],[Longitude],[MinElapsedTimeForVisit],[Name],[Radius]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[PointOfInterest] ADD  CONSTRAINT [DF_PointOfInterest_MinElapsedTimeForVisit]  DEFAULT ((15)) FOR [MinElapsedTimeForVisit]
ALTER TABLE [dbo].[PointOfInterest] ADD  CONSTRAINT [DF_PointOfInterest_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[PointOfInterest] ADD  CONSTRAINT [DF_PointOfInterest_Pending]  DEFAULT ((0)) FOR [Pending]
ALTER TABLE [dbo].[PointOfInterest]  WITH NOCHECK ADD  CONSTRAINT [FK_PointOfInterest_Department] FOREIGN KEY([IdDepartment])
REFERENCES [dbo].[Department] ([Id])
ALTER TABLE [dbo].[PointOfInterest] CHECK CONSTRAINT [FK_PointOfInterest_Department]
ALTER TABLE [dbo].[PointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterest_Son] FOREIGN KEY([SonId])
REFERENCES [dbo].[Son] ([Id])
ALTER TABLE [dbo].[PointOfInterest] CHECK CONSTRAINT [FK_PointOfInterest_Son]
ALTER TABLE [dbo].[PointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterest_User] FOREIGN KEY([LocationChangeUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[PointOfInterest] CHECK CONSTRAINT [FK_PointOfInterest_User]
