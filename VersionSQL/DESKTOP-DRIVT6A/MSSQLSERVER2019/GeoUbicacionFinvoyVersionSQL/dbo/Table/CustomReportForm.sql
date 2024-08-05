/****** Object:  Table [dbo].[CustomReportForm]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomReportForm](
	[IdCustomReport] [int] NOT NULL,
	[IdForm] [int] NOT NULL,
 CONSTRAINT [PK_CustomReportForm_1] PRIMARY KEY CLUSTERED 
(
	[IdCustomReport] ASC,
	[IdForm] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomReportForm]  WITH CHECK ADD  CONSTRAINT [FK_CustomReportForm_CustomReport] FOREIGN KEY([IdCustomReport])
REFERENCES [dbo].[CustomReport] ([Id])
ALTER TABLE [dbo].[CustomReportForm] CHECK CONSTRAINT [FK_CustomReportForm_CustomReport]
ALTER TABLE [dbo].[CustomReportForm]  WITH CHECK ADD  CONSTRAINT [FK_CustomReportForm_Form] FOREIGN KEY([IdForm])
REFERENCES [dbo].[Form] ([Id])
ALTER TABLE [dbo].[CustomReportForm] CHECK CONSTRAINT [FK_CustomReportForm_Form]
