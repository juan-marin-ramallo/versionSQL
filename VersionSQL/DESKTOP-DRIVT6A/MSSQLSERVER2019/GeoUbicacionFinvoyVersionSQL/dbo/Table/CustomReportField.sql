/****** Object:  Table [dbo].[CustomReportField]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomReportField](
	[IdCustomReport] [int] NOT NULL,
	[IdField] [int] NOT NULL,
 CONSTRAINT [PK_CustomReportField] PRIMARY KEY CLUSTERED 
(
	[IdCustomReport] ASC,
	[IdField] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomReportField]  WITH CHECK ADD  CONSTRAINT [FK_CustomReportField_CustomReport] FOREIGN KEY([IdCustomReport])
REFERENCES [dbo].[CustomReport] ([Id])
ALTER TABLE [dbo].[CustomReportField] CHECK CONSTRAINT [FK_CustomReportField_CustomReport]
ALTER TABLE [dbo].[CustomReportField]  WITH CHECK ADD  CONSTRAINT [FK_CustomReportField_Field] FOREIGN KEY([IdField])
REFERENCES [dbo].[Field] ([Id])
ALTER TABLE [dbo].[CustomReportField] CHECK CONSTRAINT [FK_CustomReportField_Field]
