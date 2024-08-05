/****** Object:  Table [dbo].[CustomReportTypeFieldGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomReportTypeFieldGroup](
	[IdCustomReportType] [int] NOT NULL,
	[IdFieldGroup] [int] NOT NULL,
 CONSTRAINT [PK_CustomReportTypeFieldGroup] PRIMARY KEY CLUSTERED 
(
	[IdCustomReportType] ASC,
	[IdFieldGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomReportTypeFieldGroup]  WITH CHECK ADD  CONSTRAINT [FK_CustomReportTypeFieldGroup_CustomReportType] FOREIGN KEY([IdCustomReportType])
REFERENCES [dbo].[CustomReportType] ([Id])
ALTER TABLE [dbo].[CustomReportTypeFieldGroup] CHECK CONSTRAINT [FK_CustomReportTypeFieldGroup_CustomReportType]
ALTER TABLE [dbo].[CustomReportTypeFieldGroup]  WITH CHECK ADD  CONSTRAINT [FK_CustomReportTypeFieldGroup_FieldGroup] FOREIGN KEY([IdFieldGroup])
REFERENCES [dbo].[FieldGroup] ([Id])
ALTER TABLE [dbo].[CustomReportTypeFieldGroup] CHECK CONSTRAINT [FK_CustomReportTypeFieldGroup_FieldGroup]
