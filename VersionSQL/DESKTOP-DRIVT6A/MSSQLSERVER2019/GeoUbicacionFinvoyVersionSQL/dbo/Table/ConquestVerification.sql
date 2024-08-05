/****** Object:  Table [dbo].[ConquestVerification]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ConquestVerification](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdConquest] [int] NOT NULL,
	[IdPersonOfInterest] [int] NULL,
	[IdUser] [int] NULL,
	[Description] [varchar](250) NULL,
	[Date] [datetime] NOT NULL,
	[IsVerified] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ConquestVerifications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ConquestVerification] ADD  CONSTRAINT [DF_ConquestVerification_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
ALTER TABLE [dbo].[ConquestVerification]  WITH CHECK ADD  CONSTRAINT [FK_ConquestVerification_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[ConquestVerification] CHECK CONSTRAINT [FK_ConquestVerification_PersonOfInterest]
ALTER TABLE [dbo].[ConquestVerification]  WITH CHECK ADD  CONSTRAINT [FK_ConquestVerification_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[ConquestVerification] CHECK CONSTRAINT [FK_ConquestVerification_User]
ALTER TABLE [dbo].[ConquestVerification]  WITH CHECK ADD  CONSTRAINT [FK_ConquestVerifications_Conquests] FOREIGN KEY([IdConquest])
REFERENCES [dbo].[Conquest] ([Id])
ALTER TABLE [dbo].[ConquestVerification] CHECK CONSTRAINT [FK_ConquestVerifications_Conquests]
