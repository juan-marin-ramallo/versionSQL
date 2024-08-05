/****** Object:  Table [dbo].[ProductReportAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductReportAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProductReportSection] [int] NULL,
	[Name] [varchar](250) NULL,
	[IdType] [int] NOT NULL,
	[DefaultValue] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[IdUser] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[Order] [int] NOT NULL,
	[Required] [bit] NOT NULL,
	[FullDeleted] [bit] NOT NULL,
	[IsStar] [bit] NOT NULL,
 CONSTRAINT [PK_ProductReportCustomAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[ProductReportAttribute] ADD  CONSTRAINT [DF_ProductReportCustomAttribute_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[ProductReportAttribute] ADD  CONSTRAINT [DF_ProductReportAttribute_Required]  DEFAULT ((0)) FOR [Required]
ALTER TABLE [dbo].[ProductReportAttribute] ADD  CONSTRAINT [DF_ProductReportAttribute_FullDeleted]  DEFAULT ((0)) FOR [FullDeleted]
ALTER TABLE [dbo].[ProductReportAttribute] ADD  CONSTRAINT [DF_ProductReportAttribute_IsStar]  DEFAULT ((0)) FOR [IsStar]
ALTER TABLE [dbo].[ProductReportAttribute]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportAttribute_ProductReportAttributeType] FOREIGN KEY([IdType])
REFERENCES [dbo].[ProductReportAttributeType] ([Id])
ALTER TABLE [dbo].[ProductReportAttribute] CHECK CONSTRAINT [FK_ProductReportAttribute_ProductReportAttributeType]
ALTER TABLE [dbo].[ProductReportAttribute]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportAttribute_ProductReportSection] FOREIGN KEY([IdProductReportSection])
REFERENCES [dbo].[ProductReportSection] ([Id])
ALTER TABLE [dbo].[ProductReportAttribute] CHECK CONSTRAINT [FK_ProductReportAttribute_ProductReportSection]
ALTER TABLE [dbo].[ProductReportAttribute]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportAttribute_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[ProductReportAttribute] CHECK CONSTRAINT [FK_ProductReportAttribute_User]
