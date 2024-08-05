/****** Object:  Table [dbo].[ProductMissingPointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductMissingPointOfInterest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[ReceivedDate] [datetime] NOT NULL,
	[MissingConfirmation] [bit] NULL,
	[IdProductMissingType] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[IsManual] [bit] NULL,
	[IsValid] [bit] NULL,
	[ValidationDate] [datetime] NULL,
	[ValidationImage] [varchar](512) NULL,
	[ValidationReceivedDate] [datetime] NULL,
	[ValidationDescription] [varchar](8000) NULL,
 CONSTRAINT [PK_ProductMissingPointOfInterest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ProductMissingPointOfInterest] UNIQUE NONCLUSTERED 
(
	[IdPersonOfInterest] ASC,
	[IdPointOfInterest] ASC,
	[Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_NCL_ProductMissingPointOfInterest_IdPersonOfInterest_Deleted_Date] ON [dbo].[ProductMissingPointOfInterest]
(
	[IdPersonOfInterest] ASC,
	[Deleted] ASC,
	[Date] ASC
)
INCLUDE([Id],[IdPointOfInterest],[MissingConfirmation],[IdProductMissingType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_ProductMissingPointOfInterest_Deleted_Date] ON [dbo].[ProductMissingPointOfInterest]
(
	[Deleted] ASC,
	[Date] ASC
)
INCLUDE([Id],[IdPointOfInterest],[IdPersonOfInterest],[MissingConfirmation],[IdProductMissingType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [NCL_IX_ProductMissingPointOfInterest_IdPointOfInterest_Deleted_Date] ON [dbo].[ProductMissingPointOfInterest]
(
	[IdPointOfInterest] ASC,
	[Deleted] ASC,
	[Date] ASC
)
INCLUDE([Id],[IdPersonOfInterest],[MissingConfirmation],[IdProductMissingType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[ProductMissingPointOfInterest] ADD  CONSTRAINT [DF_ProductMissingPointOfInterest_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[ProductMissingPointOfInterest] ADD  CONSTRAINT [DF_ProductMissingPointOfInterest_IsManual]  DEFAULT ((0)) FOR [IsManual]
ALTER TABLE [dbo].[ProductMissingPointOfInterest] ADD  CONSTRAINT [DF_ProductMissingPointOfInterest_IsValid]  DEFAULT (NULL) FOR [IsValid]
ALTER TABLE [dbo].[ProductMissingPointOfInterest] ADD  CONSTRAINT [DF_ProductMissingPointOfInterest_ValidationDate]  DEFAULT (NULL) FOR [ValidationDate]
ALTER TABLE [dbo].[ProductMissingPointOfInterest] ADD  CONSTRAINT [DF_ProductMissingPointOfInterest_ValidationImage]  DEFAULT (NULL) FOR [ValidationImage]
ALTER TABLE [dbo].[ProductMissingPointOfInterest] ADD  CONSTRAINT [DF_ProductMissingPointOfInterest_ValidationReceivedDate]  DEFAULT (NULL) FOR [ValidationReceivedDate]
ALTER TABLE [dbo].[ProductMissingPointOfInterest] ADD  CONSTRAINT [DF_ProductMissingPointOfInterest_ValidationDescription]  DEFAULT (NULL) FOR [ValidationDescription]
ALTER TABLE [dbo].[ProductMissingPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_ProductMissingPointOfInterest_Parameter] FOREIGN KEY([IdProductMissingType])
REFERENCES [dbo].[Parameter] ([Id])
ALTER TABLE [dbo].[ProductMissingPointOfInterest] CHECK CONSTRAINT [FK_ProductMissingPointOfInterest_Parameter]
ALTER TABLE [dbo].[ProductMissingPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_ProductMissingPointOfInterest_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[ProductMissingPointOfInterest] CHECK CONSTRAINT [FK_ProductMissingPointOfInterest_PersonOfInterest]
ALTER TABLE [dbo].[ProductMissingPointOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_ProductMissingPointOfInterest_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[ProductMissingPointOfInterest] CHECK CONSTRAINT [FK_ProductMissingPointOfInterest_PointOfInterest]
