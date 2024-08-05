/****** Object:  Table [dbo].[DocumentReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DocumentReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdDocument] [int] NULL,
	[DocumentType] [int] NULL,
	[IdPointOfInterest] [int] NULL,
	[IdPersonOfInterest] [int] NULL,
	[Date] [datetime] NULL,
	[ImageEncoded] [varbinary](max) NULL,
	[ImageEncoded2] [varbinary](max) NULL,
	[ImageEncoded3] [varbinary](max) NULL,
	[ReceivedDate] [datetime] NULL,
	[IsFullfilled] [bit] NULL,
	[ImageName] [varchar](100) NULL,
	[ImageUrl] [varchar](5000) NULL,
	[ImageName2] [varchar](100) NULL,
	[ImageUrl2] [varchar](5000) NULL,
	[ImageName3] [varchar](100) NULL,
	[ImageUrl3] [varchar](5000) NULL,
 CONSTRAINT [PK_DocumentReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[DocumentReport] ADD  CONSTRAINT [DF_DocumentReport_IsFullfilled]  DEFAULT ((0)) FOR [IsFullfilled]
ALTER TABLE [dbo].[DocumentReport]  WITH CHECK ADD  CONSTRAINT [FK_DocumentReport_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[DocumentReport] CHECK CONSTRAINT [FK_DocumentReport_PersonOfInterest]
ALTER TABLE [dbo].[DocumentReport]  WITH CHECK ADD  CONSTRAINT [FK_DocumentReport_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[DocumentReport] CHECK CONSTRAINT [FK_DocumentReport_PointOfInterest]
