/****** Object:  Table [dbo].[PersonOfInterestFiscalizationInfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterestFiscalizationInfo](
	[IdPersonOfInterest] [int] NOT NULL,
	[IsOutsourced] [bit] NOT NULL,
	[IdPlaceOfWork] [int] NULL,
	[WorkOnSundays] [bit] NOT NULL,
	[HasSplittedWorkHours] [bit] NOT NULL,
	[SplittedWorkHoursResolutionNumber] [varchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PersonOfInterestFiscalizationInfo] PRIMARY KEY CLUSTERED 
(
	[IdPersonOfInterest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PersonOfInterestFiscalizationInfo]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestFiscalizationInfo_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[PersonOfInterestFiscalizationInfo] CHECK CONSTRAINT [FK_PersonOfInterestFiscalizationInfo_PersonOfInterest]
