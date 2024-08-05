/****** Object:  Table [dbo].[Field]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Field](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](250) NOT NULL,
	[IdFieldGroup] [int] NOT NULL,
	[ColumnTitle] [varchar](200) NULL,
	[Order] [int] NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[IdCustomAttribute] [int] NULL,
	[IdProductReportAttribute] [int] NULL,
	[FullDeleted] [bit] NOT NULL,
	[IdOrderReportAttribute] [int] NULL,
	[IdAssetReportAttribute] [int] NULL,
	[IsOnlyChileanRegulation] [bit] NOT NULL,
 CONSTRAINT [PK_Field] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Field] ADD  CONSTRAINT [DF_Field_Order]  DEFAULT ((1)) FOR [Order]
ALTER TABLE [dbo].[Field] ADD  CONSTRAINT [DF_Field_SelectedByDefault]  DEFAULT ((1)) FOR [IsDefault]
ALTER TABLE [dbo].[Field] ADD  CONSTRAINT [DF_Field_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[Field] ADD  CONSTRAINT [DF_Field_FullDeleted]  DEFAULT ((0)) FOR [FullDeleted]
ALTER TABLE [dbo].[Field] ADD  CONSTRAINT [DF__Field__IsOnlyChi__21187D8D]  DEFAULT ((0)) FOR [IsOnlyChileanRegulation]
ALTER TABLE [dbo].[Field]  WITH CHECK ADD  CONSTRAINT [FK_Field_AssetReportAttribute] FOREIGN KEY([IdAssetReportAttribute])
REFERENCES [dbo].[AssetReportAttribute] ([Id])
ALTER TABLE [dbo].[Field] CHECK CONSTRAINT [FK_Field_AssetReportAttribute]
ALTER TABLE [dbo].[Field]  WITH CHECK ADD  CONSTRAINT [FK_Field_CustomAttribute] FOREIGN KEY([IdCustomAttribute])
REFERENCES [dbo].[CustomAttribute] ([Id])
ALTER TABLE [dbo].[Field] CHECK CONSTRAINT [FK_Field_CustomAttribute]
ALTER TABLE [dbo].[Field]  WITH CHECK ADD  CONSTRAINT [FK_Field_FieldGroup] FOREIGN KEY([IdFieldGroup])
REFERENCES [dbo].[FieldGroup] ([Id])
ALTER TABLE [dbo].[Field] CHECK CONSTRAINT [FK_Field_FieldGroup]
ALTER TABLE [dbo].[Field]  WITH CHECK ADD  CONSTRAINT [FK_Field_OrderReportAttribute] FOREIGN KEY([IdOrderReportAttribute])
REFERENCES [dbo].[OrderReportAttribute] ([Id])
ALTER TABLE [dbo].[Field] CHECK CONSTRAINT [FK_Field_OrderReportAttribute]
ALTER TABLE [dbo].[Field]  WITH CHECK ADD  CONSTRAINT [FK_Field_ProductReportAttribute] FOREIGN KEY([IdProductReportAttribute])
REFERENCES [dbo].[ProductReportAttribute] ([Id])
ALTER TABLE [dbo].[Field] CHECK CONSTRAINT [FK_Field_ProductReportAttribute]
