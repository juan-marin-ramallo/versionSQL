/****** Object:  Table [dbo].[AgreementPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AgreementPointOfInterest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPointOfInterest] [int] NULL,
	[IdAgreement] [int] NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_AgreementPointOfInterest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AgreementPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_AgreementPointOfInterest_AgreementPointOfInterest] FOREIGN KEY([IdAgreement])
REFERENCES [dbo].[Agreement] ([Id])
ALTER TABLE [dbo].[AgreementPointOfInterest] CHECK CONSTRAINT [FK_AgreementPointOfInterest_AgreementPointOfInterest]
ALTER TABLE [dbo].[AgreementPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_AgreementPointOfInterest_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[AgreementPointOfInterest] CHECK CONSTRAINT [FK_AgreementPointOfInterest_PointOfInterest]
