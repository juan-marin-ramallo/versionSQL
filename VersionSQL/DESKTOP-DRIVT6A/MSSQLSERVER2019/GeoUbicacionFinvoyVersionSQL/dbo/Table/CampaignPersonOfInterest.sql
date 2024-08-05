/****** Object:  Table [dbo].[CampaignPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CampaignPersonOfInterest](
	[IdCampaign] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
 CONSTRAINT [PK_PersonOfInterestCampaign] PRIMARY KEY CLUSTERED 
(
	[IdCampaign] ASC,
	[IdPersonOfInterest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CampaignPersonOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_Campaign_PersonOfInterestCampaign] FOREIGN KEY([IdCampaign])
REFERENCES [dbo].[Campaign] ([Id])
ALTER TABLE [dbo].[CampaignPersonOfInterest] CHECK CONSTRAINT [FK_Campaign_PersonOfInterestCampaign]
ALTER TABLE [dbo].[CampaignPersonOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestCampaign_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[CampaignPersonOfInterest] CHECK CONSTRAINT [FK_PersonOfInterestCampaign_PersonOfInterest]
