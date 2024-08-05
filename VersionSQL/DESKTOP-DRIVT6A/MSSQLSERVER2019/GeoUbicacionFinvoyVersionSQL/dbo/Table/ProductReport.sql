/****** Object:  Table [dbo].[ProductReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProduct] [int] NULL,
	[IdPersonOfInterest] [int] NULL,
	[IdPointOfInterest] [int] NULL,
	[Stock] [int] NULL,
	[Deleted] [bit] NULL,
	[ReportDateTime] [datetime] NULL,
	[ExpirationDate] [datetime] NULL,
	[Price] [decimal](18, 2) NULL,
	[Suggested] [int] NULL,
	[ReportReceivedDate] [datetime] NULL,
	[Comment] [varchar](100) NULL,
	[ShortStock] [bit] NULL,
	[SuggestedEmail] [varchar](50) NULL,
	[TheoricalStock] [int] NULL,
	[TheoricalPrice] [decimal](18, 2) NULL,
 CONSTRAINT [PK_ProductReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductReport]  WITH CHECK ADD  CONSTRAINT [FK_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[ProductReport] CHECK CONSTRAINT [FK_PointOfInterest]
ALTER TABLE [dbo].[ProductReport]  WITH CHECK ADD  CONSTRAINT [FK_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[ProductReport] CHECK CONSTRAINT [FK_Product]
ALTER TABLE [dbo].[ProductReport]  WITH CHECK ADD  CONSTRAINT [FK_ProductReport_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[ProductReport] CHECK CONSTRAINT [FK_ProductReport_PersonOfInterest]
