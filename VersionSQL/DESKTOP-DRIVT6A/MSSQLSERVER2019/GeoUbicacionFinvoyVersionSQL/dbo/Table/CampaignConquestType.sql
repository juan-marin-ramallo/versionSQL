/****** Object:  Table [dbo].[CampaignConquestType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CampaignConquestType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCampaign] [int] NOT NULL,
	[IdConquestType] [int] NOT NULL,
	[Weight] [int] NOT NULL,
	[Amount] [int] NOT NULL,
 CONSTRAINT [PK_CampaignConquestType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CampaignConquestType] ADD  CONSTRAINT [DF_ConquestTypesCampaigns_Amount]  DEFAULT ((1)) FOR [Amount]
ALTER TABLE [dbo].[CampaignConquestType]  WITH CHECK ADD  CONSTRAINT [FK_CampaignConquestType_Parameter] FOREIGN KEY([IdConquestType])
REFERENCES [dbo].[Parameter] ([Id])
ALTER TABLE [dbo].[CampaignConquestType] CHECK CONSTRAINT [FK_CampaignConquestType_Parameter]
ALTER TABLE [dbo].[CampaignConquestType]  WITH CHECK ADD  CONSTRAINT [FK_ConquestTypesCampaigns_Campaigns] FOREIGN KEY([IdCampaign])
REFERENCES [dbo].[Campaign] ([Id])
ALTER TABLE [dbo].[CampaignConquestType] CHECK CONSTRAINT [FK_ConquestTypesCampaigns_Campaigns]
