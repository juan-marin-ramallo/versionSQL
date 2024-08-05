/****** Object:  Table [dbo].[PersonOfInterestMobileVersion]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterestMobileVersion](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NULL,
	[Version] [varchar](10) NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_PersonOfInterestMobileVersion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PersonOfInterestMobileVersion]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestMobileVersion_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[PersonOfInterestMobileVersion] CHECK CONSTRAINT [FK_PersonOfInterestMobileVersion_PersonOfInterest]
