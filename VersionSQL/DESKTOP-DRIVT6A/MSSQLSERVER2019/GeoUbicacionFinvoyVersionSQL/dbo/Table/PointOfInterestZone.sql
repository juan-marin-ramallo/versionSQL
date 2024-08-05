/****** Object:  Table [dbo].[PointOfInterestZone]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PointOfInterestZone](
	[IdPointOfInterest] [int] NOT NULL,
	[IdZone] [int] NOT NULL,
 CONSTRAINT [PK_PointOfInterestZone] PRIMARY KEY CLUSTERED 
(
	[IdPointOfInterest] ASC,
	[IdZone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PointOfInterestZone]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterestZone_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[PointOfInterestZone] CHECK CONSTRAINT [FK_PointOfInterestZone_PointOfInterest]
ALTER TABLE [dbo].[PointOfInterestZone]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterestZone_Zone] FOREIGN KEY([IdZone])
REFERENCES [dbo].[Zone] ([Id])
ALTER TABLE [dbo].[PointOfInterestZone] CHECK CONSTRAINT [FK_PointOfInterestZone_Zone]
