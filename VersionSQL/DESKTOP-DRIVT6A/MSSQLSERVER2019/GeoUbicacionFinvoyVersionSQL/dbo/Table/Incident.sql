/****** Object:  Table [dbo].[Incident]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Incident](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](250) NULL,
	[ImageEncoded] [varbinary](max) NULL,
	[ImageEncoded2] [varbinary](max) NULL,
	[ImageEncoded3] [varbinary](max) NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ReceivedDate] [datetime] NULL,
	[IdIncidentType] [int] NULL,
	[ImageName] [varchar](100) NULL,
	[ImageUrl] [varchar](5000) NULL,
	[ImageName2] [varchar](100) NULL,
	[ImageUrl2] [varchar](5000) NULL,
	[ImageName3] [varchar](100) NULL,
	[ImageUrl3] [varchar](5000) NULL,
 CONSTRAINT [PK_Incident] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Incident]  WITH CHECK ADD  CONSTRAINT [FK_Incident_IncidentType] FOREIGN KEY([IdIncidentType])
REFERENCES [dbo].[IncidentType] ([Id])
ALTER TABLE [dbo].[Incident] CHECK CONSTRAINT [FK_Incident_IncidentType]
ALTER TABLE [dbo].[Incident]  WITH CHECK ADD  CONSTRAINT [FK_Incident_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[Incident] CHECK CONSTRAINT [FK_Incident_PersonOfInterest]
ALTER TABLE [dbo].[Incident]  WITH CHECK ADD  CONSTRAINT [FK_Incident_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[Incident] CHECK CONSTRAINT [FK_Incident_PointOfInterest]
