/****** Object:  Table [dbo].[MarkHashInformation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MarkHashInformation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](5) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Latitude] [decimal](25, 20) NOT NULL,
	[Longitude] [decimal](25, 20) NOT NULL,
	[IsOnline] [bit] NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[PersonOfInterestFullName] [varchar](100) NOT NULL,
	[PersonOfInterestIdentifier] [varchar](20) NOT NULL,
	[IdPointOfInterest] [int] NULL,
	[PointOfInterestName] [varchar](100) NULL,
	[PointOfInterestIdentifier] [varchar](50) NULL,
	[HashCodeResult] [varchar](1000) NOT NULL,
	[IdMark] [int] NOT NULL,
	[CompanyName] [varchar](250) NULL,
	[CompanyRUT] [varchar](250) NULL,
	[CompanyAddress] [varchar](250) NULL,
 CONSTRAINT [PK_MarkHashInformation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MarkHashInformation]  WITH CHECK ADD  CONSTRAINT [FK_MarkHashInformation_Mark] FOREIGN KEY([IdMark])
REFERENCES [dbo].[Mark] ([Id])
ALTER TABLE [dbo].[MarkHashInformation] CHECK CONSTRAINT [FK_MarkHashInformation_Mark]
ALTER TABLE [dbo].[MarkHashInformation]  WITH NOCHECK ADD  CONSTRAINT [FK_MarkHashInformation_MarkType] FOREIGN KEY([Type])
REFERENCES [dbo].[MarkType] ([Code])
ALTER TABLE [dbo].[MarkHashInformation] CHECK CONSTRAINT [FK_MarkHashInformation_MarkType]
ALTER TABLE [dbo].[MarkHashInformation]  WITH CHECK ADD  CONSTRAINT [FK_MarkHashInformation_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[MarkHashInformation] CHECK CONSTRAINT [FK_MarkHashInformation_PersonOfInterest]
ALTER TABLE [dbo].[MarkHashInformation]  WITH CHECK ADD  CONSTRAINT [FK_MarkHashInformation_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[MarkHashInformation] CHECK CONSTRAINT [FK_MarkHashInformation_PointOfInterest]
