/****** Object:  Table [dbo].[CustomReportType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomReportType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Order] [int] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[IdPermission] [smallint] NULL,
 CONSTRAINT [PK_CustomReportType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomReportType] ADD  CONSTRAINT [DF_CustomReportType_Order]  DEFAULT ((1)) FOR [Order]
ALTER TABLE [dbo].[CustomReportType] ADD  CONSTRAINT [DF_Table_1_Deleted]  DEFAULT ((0)) FOR [Enabled]
ALTER TABLE [dbo].[CustomReportType]  WITH CHECK ADD  CONSTRAINT [FK_CustomReportType_Permission] FOREIGN KEY([IdPermission])
REFERENCES [dbo].[Permission] ([Id])
ALTER TABLE [dbo].[CustomReportType] CHECK CONSTRAINT [FK_CustomReportType_Permission]
