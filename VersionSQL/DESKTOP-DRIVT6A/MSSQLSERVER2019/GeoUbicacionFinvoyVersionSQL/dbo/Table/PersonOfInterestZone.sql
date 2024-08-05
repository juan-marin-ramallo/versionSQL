/****** Object:  Table [dbo].[PersonOfInterestZone]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterestZone](
	[IdPersonOfInterest] [int] NOT NULL,
	[IdZone] [int] NOT NULL,
 CONSTRAINT [PK_PersonOfInterestZone] PRIMARY KEY CLUSTERED 
(
	[IdPersonOfInterest] ASC,
	[IdZone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PersonOfInterestZone]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestZone_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[PersonOfInterestZone] CHECK CONSTRAINT [FK_PersonOfInterestZone_PersonOfInterest]
ALTER TABLE [dbo].[PersonOfInterestZone]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestZone_Zone] FOREIGN KEY([IdZone])
REFERENCES [dbo].[Zone] ([Id])
ALTER TABLE [dbo].[PersonOfInterestZone] CHECK CONSTRAINT [FK_PersonOfInterestZone_Zone]
