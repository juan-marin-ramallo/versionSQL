/****** Object:  UserDefinedTableType [dbo].[CampaignConquestTypeTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[CampaignConquestTypeTableType] AS TABLE(
	[Id] [int] NOT NULL,
	[IdConquestType] [int] NOT NULL,
	[Weight] [int] NOT NULL,
	[Amount] [int] NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[IdConquestType] ASC,
	[Weight] ASC,
	[Amount] ASC
)WITH (IGNORE_DUP_KEY = ON)
)
