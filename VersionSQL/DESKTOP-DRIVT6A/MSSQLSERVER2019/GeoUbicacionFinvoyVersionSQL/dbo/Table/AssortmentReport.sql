/****** Object:  Table [dbo].[AssortmentReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssortmentReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[ReceivedDate] [datetime] NOT NULL,
	[CompliancePercentage] [decimal](5, 2) NOT NULL,
	[NonCompliancePercentage] [decimal](5, 2) NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_AssortmentReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AssortmentReport]  WITH CHECK ADD  CONSTRAINT [FK_AssortmentReport_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[AssortmentReport] CHECK CONSTRAINT [FK_AssortmentReport_PersonOfInterest]
ALTER TABLE [dbo].[AssortmentReport]  WITH CHECK ADD  CONSTRAINT [FK_AssortmentReport_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[AssortmentReport] CHECK CONSTRAINT [FK_AssortmentReport_PointOfInterest]
