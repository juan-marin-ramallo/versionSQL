/****** Object:  Table [dbo].[CampaignPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CampaignPointOfInterest](
	[IdCampaign] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
 CONSTRAINT [PK_PointOfInterestCampaigns] PRIMARY KEY CLUSTERED 
(
	[IdCampaign] ASC,
	[IdPointOfInterest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CampaignPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_Campaigns_POI] FOREIGN KEY([IdCampaign])
REFERENCES [dbo].[Campaign] ([Id])
ALTER TABLE [dbo].[CampaignPointOfInterest] CHECK CONSTRAINT [FK_Campaigns_POI]
ALTER TABLE [dbo].[CampaignPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterest_Campaigns] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[CampaignPointOfInterest] CHECK CONSTRAINT [FK_PointOfInterest_Campaigns]
