/****** Object:  Table [dbo].[Campaign]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Campaign](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](150) NOT NULL,
	[Description] [varchar](max) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[Prize] [varchar](250) NULL,
	[PersonOfInterestIdWinner] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[AllPointOfInterest] [bit] NULL,
	[AllPersonOfInterest] [bit] NULL,
	[DeletedDate] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_IncentiveCampaigns] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Campaign] ADD  CONSTRAINT [DF_Campaign_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[Campaign] ADD  CONSTRAINT [DF_Campaign_CreatedDated]  DEFAULT (getutcdate()) FOR [CreatedDate]
ALTER TABLE [dbo].[Campaign]  WITH CHECK ADD  CONSTRAINT [FK_Campaigns_PersonOfInterest] FOREIGN KEY([PersonOfInterestIdWinner])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[Campaign] CHECK CONSTRAINT [FK_Campaigns_PersonOfInterest]
