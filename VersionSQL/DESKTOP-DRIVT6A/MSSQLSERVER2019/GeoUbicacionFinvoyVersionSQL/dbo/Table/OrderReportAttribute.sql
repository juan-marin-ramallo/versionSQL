/****** Object:  Table [dbo].[OrderReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[OrderReportAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[IdType] [int] NOT NULL,
	[DefaultValue] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[IdUser] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[Order] [int] NOT NULL,
	[Required] [bit] NOT NULL,
	[Enabled] [bit] NOT NULL,
 CONSTRAINT [PK_OrderReportAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[OrderReportAttribute] ADD  CONSTRAINT [DF_OrderReportAttribute_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[OrderReportAttribute] ADD  CONSTRAINT [DF_OrderReportAttribute_Required]  DEFAULT ((0)) FOR [Required]
ALTER TABLE [dbo].[OrderReportAttribute] ADD  CONSTRAINT [DF_OrderReportAttribute_FullDeleted]  DEFAULT ((0)) FOR [Enabled]
ALTER TABLE [dbo].[OrderReportAttribute]  WITH CHECK ADD  CONSTRAINT [FK_OrderReportAttribute_ProductReportAttributeType] FOREIGN KEY([IdType])
REFERENCES [dbo].[ProductReportAttributeType] ([Id])
ALTER TABLE [dbo].[OrderReportAttribute] CHECK CONSTRAINT [FK_OrderReportAttribute_ProductReportAttributeType]
ALTER TABLE [dbo].[OrderReportAttribute]  WITH CHECK ADD  CONSTRAINT [FK_OrderReportAttribute_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[OrderReportAttribute] CHECK CONSTRAINT [FK_OrderReportAttribute_User]
