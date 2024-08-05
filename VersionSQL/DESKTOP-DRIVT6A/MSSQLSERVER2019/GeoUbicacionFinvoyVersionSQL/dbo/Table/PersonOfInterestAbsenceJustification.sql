/****** Object:  Table [dbo].[PersonOfInterestAbsenceJustification]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterestAbsenceJustification](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[SavedDate] [datetime] NOT NULL,
	[IdAbsenceReason] [int] NOT NULL,
	[Comments] [varchar](5000) NULL,
 CONSTRAINT [PK_PersonOfInterestAbsenceJustification] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PersonOfInterestAbsenceJustification]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestAbsenceJustification_AbsenceReason] FOREIGN KEY([IdAbsenceReason])
REFERENCES [dbo].[AbsenceReason] ([Id])
ALTER TABLE [dbo].[PersonOfInterestAbsenceJustification] CHECK CONSTRAINT [FK_PersonOfInterestAbsenceJustification_AbsenceReason]
ALTER TABLE [dbo].[PersonOfInterestAbsenceJustification]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestAbsenceJustification_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[PersonOfInterestAbsenceJustification] CHECK CONSTRAINT [FK_PersonOfInterestAbsenceJustification_PersonOfInterest]
