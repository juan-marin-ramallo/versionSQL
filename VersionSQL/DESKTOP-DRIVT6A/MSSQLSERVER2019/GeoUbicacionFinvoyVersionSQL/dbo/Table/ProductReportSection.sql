/****** Object:  Table [dbo].[ProductReportSection]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductReportSection](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](250) NULL,
	[CreatedDate] [datetime] NULL,
	[IdUser] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[Order] [int] NOT NULL,
	[FullDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_ProductReportSection] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductReportSection] ADD  CONSTRAINT [DF_ProductReportSection_FullDeleted]  DEFAULT ((0)) FOR [FullDeleted]
ALTER TABLE [dbo].[ProductReportSection]  WITH CHECK ADD  CONSTRAINT [FK_ProductReportSection_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[ProductReportSection] CHECK CONSTRAINT [FK_ProductReportSection_User]
