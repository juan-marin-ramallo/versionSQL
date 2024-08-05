/****** Object:  Table [dbo].[FormReportFormatElementOptions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[FormReportFormatElementOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdFormatElement] [int] NULL,
	[IdFormatOptions] [int] NULL,
 CONSTRAINT [PK_FormReportFormatElementOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FormReportFormatElementOptions]  WITH CHECK ADD  CONSTRAINT [FK_FormReportFormatElementOptions_FormReportFormatElement] FOREIGN KEY([IdFormatElement])
REFERENCES [dbo].[FormReportFormatElement] ([Id])
ALTER TABLE [dbo].[FormReportFormatElementOptions] CHECK CONSTRAINT [FK_FormReportFormatElementOptions_FormReportFormatElement]
ALTER TABLE [dbo].[FormReportFormatElementOptions]  WITH CHECK ADD  CONSTRAINT [FK_FormReportFormatElementOptions_FormReportFormatOptions] FOREIGN KEY([IdFormatOptions])
REFERENCES [dbo].[FormReportFormatOptions] ([Id])
ALTER TABLE [dbo].[FormReportFormatElementOptions] CHECK CONSTRAINT [FK_FormReportFormatElementOptions_FormReportFormatOptions]
