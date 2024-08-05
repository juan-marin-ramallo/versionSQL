/****** Object:  Table [dbo].[PromotionPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PromotionPointOfInterest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPointOfInterest] [int] NULL,
	[IdPromotion] [int] NULL,
	[Date] [datetime] NULL,
 CONSTRAINT [PK_PromotionPointOfInterest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NCL_IX_PromotionPointOfInterest_IdPromotion] ON [dbo].[PromotionPointOfInterest]
(
	[IdPromotion] ASC
)
INCLUDE([IdPointOfInterest]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[PromotionPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_PromotionPointOfInterest_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[PromotionPointOfInterest] CHECK CONSTRAINT [FK_PromotionPointOfInterest_PointOfInterest]
ALTER TABLE [dbo].[PromotionPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_PromotionPointOfInterest_Promotion] FOREIGN KEY([IdPromotion])
REFERENCES [dbo].[Promotion] ([Id])
ALTER TABLE [dbo].[PromotionPointOfInterest] CHECK CONSTRAINT [FK_PromotionPointOfInterest_Promotion]
