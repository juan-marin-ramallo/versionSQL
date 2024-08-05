/****** Object:  Table [dbo].[OrderReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[OrderReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[OrderDateTime] [datetime] NOT NULL,
	[ReceivedDateTime] [datetime] NOT NULL,
	[Comment] [varchar](250) NULL,
	[Emails] [varchar](500) NULL,
	[OrderTotalQuantity] [int] NULL,
	[Status] [smallint] NOT NULL,
	[StatusChangeDate] [datetime] NULL,
	[StatusComment] [varchar](4096) NULL,
	[AttachmentName] [varchar](256) NULL,
	[AttachmentUrl] [varchar](2048) NULL,
 CONSTRAINT [PK_OrderReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrderReport] ADD  CONSTRAINT [DF_OrderReport_Status]  DEFAULT ((1)) FOR [Status]
ALTER TABLE [dbo].[OrderReport]  WITH CHECK ADD  CONSTRAINT [FK_OrderReport_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[OrderReport] CHECK CONSTRAINT [FK_OrderReport_PersonOfInterest]
ALTER TABLE [dbo].[OrderReport]  WITH CHECK ADD  CONSTRAINT [FK_OrderReport_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[OrderReport] CHECK CONSTRAINT [FK_OrderReport_PointOfInterest]
