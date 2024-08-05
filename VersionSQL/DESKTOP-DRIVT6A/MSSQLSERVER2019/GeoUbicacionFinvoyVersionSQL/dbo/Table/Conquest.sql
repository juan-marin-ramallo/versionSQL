/****** Object:  Table [dbo].[Conquest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Conquest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ConquestTypeId] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Description] [varchar](250) NULL,
	[Amount] [decimal](8, 2) NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Conquests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Conquest] ADD  CONSTRAINT [DF_Conquest_Amount]  DEFAULT ((1)) FOR [Amount]
ALTER TABLE [dbo].[Conquest] ADD  CONSTRAINT [DF_Conquest_Active]  DEFAULT ((1)) FOR [Active]
ALTER TABLE [dbo].[Conquest] ADD  CONSTRAINT [DF_Conquest_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
ALTER TABLE [dbo].[Conquest]  WITH CHECK ADD  CONSTRAINT [FK_Conquests_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[Conquest] CHECK CONSTRAINT [FK_Conquests_PersonOfInterest]
ALTER TABLE [dbo].[Conquest]  WITH CHECK ADD  CONSTRAINT [FK_Conquests_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[Conquest] CHECK CONSTRAINT [FK_Conquests_PointOfInterest]
