/****** Object:  Table [dbo].[ShareOfShelfReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ShareOfShelfReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[GrandTotal] [decimal](18, 2) NOT NULL,
	[ReceivedDate] [datetime] NULL,
	[IsManual] [bit] NOT NULL,
	[IsValid] [bit] NULL,
	[ValidationDate] [datetime] NULL,
	[ValidationImage] [varchar](512) NULL,
	[ValidationReceivedDate] [datetime] NULL,
	[ValidationDescription] [varchar](8000) NULL,
	[DiscardReason] [varchar](2000) NULL,
 CONSTRAINT [PK_ShareOfShelfReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ShareOfShelfReport] ADD  CONSTRAINT [DF_ShareOfShelfReport_Date]  DEFAULT (getutcdate()) FOR [Date]
ALTER TABLE [dbo].[ShareOfShelfReport] ADD  CONSTRAINT [DF_ShareOfShelfReport_Total]  DEFAULT ((0)) FOR [GrandTotal]
ALTER TABLE [dbo].[ShareOfShelfReport] ADD  CONSTRAINT [DF_ShareOfShelfReport_IsManual]  DEFAULT ((1)) FOR [IsManual]
ALTER TABLE [dbo].[ShareOfShelfReport] ADD  CONSTRAINT [DF_ShareOfShelfReport_IsValid]  DEFAULT ((1)) FOR [IsValid]
ALTER TABLE [dbo].[ShareOfShelfReport]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfReport_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[ShareOfShelfReport] CHECK CONSTRAINT [FK_ShareOfShelfReport_PersonOfInterest]
ALTER TABLE [dbo].[ShareOfShelfReport]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfReport_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[ShareOfShelfReport] CHECK CONSTRAINT [FK_ShareOfShelfReport_PointOfInterest]
