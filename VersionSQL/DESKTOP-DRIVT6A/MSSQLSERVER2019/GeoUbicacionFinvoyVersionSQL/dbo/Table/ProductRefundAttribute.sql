/****** Object:  Table [dbo].[ProductRefundAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductRefundAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[IdType] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[Deleted] [bit] NOT NULL,
	[Order] [int] NULL,
	[Required] [bit] NULL,
	[DefaultValue] [varchar](500) NULL,
	[IdUser] [int] NULL,
	[FullDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_ProductRefundAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductRefundAttribute] ADD  CONSTRAINT [DF_ProductRefundAttribute_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[ProductRefundAttribute] ADD  CONSTRAINT [DF_ProductRefundAttribute_FullDeleted]  DEFAULT ((0)) FOR [FullDeleted]
ALTER TABLE [dbo].[ProductRefundAttribute]  WITH CHECK ADD  CONSTRAINT [FK_ProductRefundAttribute_ProductReportAttributeType] FOREIGN KEY([IdType])
REFERENCES [dbo].[ProductReportAttributeType] ([Id])
ALTER TABLE [dbo].[ProductRefundAttribute] CHECK CONSTRAINT [FK_ProductRefundAttribute_ProductReportAttributeType]
ALTER TABLE [dbo].[ProductRefundAttribute]  WITH CHECK ADD  CONSTRAINT [FK_ProductRefundAttribute_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[ProductRefundAttribute] CHECK CONSTRAINT [FK_ProductRefundAttribute_User]
