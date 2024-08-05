/****** Object:  Table [dbo].[PersonOfInterestAbsence]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterestAbsence](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[FromSavedDate] [datetime] NOT NULL,
	[ToDate] [datetime] NULL,
	[ToSavedDate] [datetime] NULL,
	[IdAbsenceReason] [int] NULL,
	[Comments] [varchar](5000) NULL,
 CONSTRAINT [PK_PersonOfInterestAbsence] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PersonOfInterestAbsence]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestAbsence_AbsenceReason] FOREIGN KEY([IdAbsenceReason])
REFERENCES [dbo].[AbsenceReason] ([Id])
ALTER TABLE [dbo].[PersonOfInterestAbsence] CHECK CONSTRAINT [FK_PersonOfInterestAbsence_AbsenceReason]
ALTER TABLE [dbo].[PersonOfInterestAbsence]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestAbsence_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[PersonOfInterestAbsence] CHECK CONSTRAINT [FK_PersonOfInterestAbsence_PersonOfInterest]
