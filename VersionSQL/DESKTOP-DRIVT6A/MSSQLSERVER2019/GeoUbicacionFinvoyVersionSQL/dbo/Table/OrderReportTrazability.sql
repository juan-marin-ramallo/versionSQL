/****** Object:  Table [dbo].[OrderReportTrazability]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[OrderReportTrazability](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdOrderReport] [int] NOT NULL,
	[OrderDateTime] [datetime] NOT NULL,
	[ReceivedDateTime] [datetime] NOT NULL,
	[Status] [smallint] NULL,
	[IdProduct] [int] NULL,
	[ProductName] [varchar](100) NULL,
	[ProductPrice] [decimal](18, 3) NULL,
	[Quantity] [int] NULL,
	[IsModification] [bit] NOT NULL,
	[IdPersonOfInterest] [int] NULL,
	[IdUser] [int] NULL,
 CONSTRAINT [PK_OrderReportTrazability] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrderReportTrazability] ADD  CONSTRAINT [DF__OrderRepo__IsMod__6B268130]  DEFAULT ((0)) FOR [IsModification]
ALTER TABLE [dbo].[OrderReportTrazability] ADD  CONSTRAINT [DF__OrderRepo__IdPer__03F22EFA]  DEFAULT ((0)) FOR [IdPersonOfInterest]
ALTER TABLE [dbo].[OrderReportTrazability]  WITH CHECK ADD  CONSTRAINT [FK_OrderReportTrazability_OrderReport] FOREIGN KEY([IdOrderReport])
REFERENCES [dbo].[OrderReport] ([Id])
ALTER TABLE [dbo].[OrderReportTrazability] CHECK CONSTRAINT [FK_OrderReportTrazability_OrderReport]
ALTER TABLE [dbo].[OrderReportTrazability]  WITH CHECK ADD  CONSTRAINT [FK_OrderReportTrazability_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[OrderReportTrazability] CHECK CONSTRAINT [FK_OrderReportTrazability_Product]
