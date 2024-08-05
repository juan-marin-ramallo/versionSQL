/****** Object:  Table [dbo].[ConquestCampaign]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ConquestCampaign](
	[IdConquest] [int] NOT NULL,
	[IdCampaign] [int] NOT NULL,
 CONSTRAINT [PK_ConquestCampaign] PRIMARY KEY CLUSTERED 
(
	[IdConquest] ASC,
	[IdCampaign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ConquestCampaign]  WITH CHECK ADD  CONSTRAINT [FK_ConquestCampaign_Campaign] FOREIGN KEY([IdCampaign])
REFERENCES [dbo].[Campaign] ([Id])
ALTER TABLE [dbo].[ConquestCampaign] CHECK CONSTRAINT [FK_ConquestCampaign_Campaign]
ALTER TABLE [dbo].[ConquestCampaign]  WITH CHECK ADD  CONSTRAINT [FK_ConquestCampaign_Conquest] FOREIGN KEY([IdConquest])
REFERENCES [dbo].[Conquest] ([Id])
ALTER TABLE [dbo].[ConquestCampaign] CHECK CONSTRAINT [FK_ConquestCampaign_Conquest]
