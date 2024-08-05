/****** Object:  Table [dbo].[CustomReportCustomReportType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomReportCustomReportType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCustomReport] [int] NOT NULL,
	[IdCustomReportType] [int] NOT NULL,
	[IdForm] [int] NULL,
 CONSTRAINT [PK_CustomReportCustomReportType_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomReportCustomReportType]  WITH CHECK ADD  CONSTRAINT [FK_CustomReportCustomReportType_CustomReport] FOREIGN KEY([IdCustomReport])
REFERENCES [dbo].[CustomReport] ([Id])
ALTER TABLE [dbo].[CustomReportCustomReportType] CHECK CONSTRAINT [FK_CustomReportCustomReportType_CustomReport]
ALTER TABLE [dbo].[CustomReportCustomReportType]  WITH CHECK ADD  CONSTRAINT [FK_CustomReportCustomReportType_CustomReportType] FOREIGN KEY([IdCustomReportType])
REFERENCES [dbo].[CustomReportType] ([Id])
ALTER TABLE [dbo].[CustomReportCustomReportType] CHECK CONSTRAINT [FK_CustomReportCustomReportType_CustomReportType]
ALTER TABLE [dbo].[CustomReportCustomReportType]  WITH CHECK ADD  CONSTRAINT [FK_CustomReportCustomReportType_Form] FOREIGN KEY([IdForm])
REFERENCES [dbo].[Form] ([Id])
ALTER TABLE [dbo].[CustomReportCustomReportType] CHECK CONSTRAINT [FK_CustomReportCustomReportType_Form]
