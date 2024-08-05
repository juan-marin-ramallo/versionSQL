/****** Object:  Table [dbo].[ProductReportDynamic]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductReportDynamic](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProduct] [int] NULL,
	[IdPersonOfInterest] [int] NULL,
	[IdPointOfInterest] [int] NULL,
	[Deleted] [bit] NULL,
	[ReportDateTime] [datetime] NULL,
	[ReportReceivedDate] [datetime] NULL,
	[TheoricalStock] [int] NULL,
	[TheoricalPrice] [decimal](18, 2) NULL,
	[Email] [varchar](50) NULL,
	[IdEditedUser] [int] NULL,
	[EditedDate] [datetime] NULL,
	[EditedReason] [varchar](4000) NULL,
	[Dynamic] [varchar](100) NULL,
 CONSTRAINT [PK_ProductReportDynamic] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NCL_IC_ProductReportDynamic_ReportDateTime] ON [dbo].[ProductReportDynamic]
(
	[ReportDateTime] ASC
)
INCLUDE([Id],[IdProduct],[IdPersonOfInterest],[IdPointOfInterest],[TheoricalStock],[TheoricalPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_ProductReportDynamic_IdPersonOfInterest] ON [dbo].[ProductReportDynamic]
(
	[IdPersonOfInterest] ASC
)
INCLUDE([IdPointOfInterest],[IdProduct],[ReportDateTime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[ProductReportDynamic]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportDynamic_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[ProductReportDynamic] CHECK CONSTRAINT [FK_ProductReportDynamic_PersonOfInterest]
ALTER TABLE [dbo].[ProductReportDynamic]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportDynamic_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[ProductReportDynamic] CHECK CONSTRAINT [FK_ProductReportDynamic_PointOfInterest]
ALTER TABLE [dbo].[ProductReportDynamic]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportDynamic_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[ProductReportDynamic] CHECK CONSTRAINT [FK_ProductReportDynamic_Product]
ALTER TABLE [dbo].[ProductReportDynamic]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportDynamic_User] FOREIGN KEY([IdEditedUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[ProductReportDynamic] CHECK CONSTRAINT [FK_ProductReportDynamic_User]
