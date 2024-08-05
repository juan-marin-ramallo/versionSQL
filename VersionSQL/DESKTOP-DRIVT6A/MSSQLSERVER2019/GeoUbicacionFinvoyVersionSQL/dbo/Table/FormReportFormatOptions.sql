/****** Object:  Table [dbo].[FormReportFormatOptions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[FormReportFormatOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[IdCustomAttribute] [int] NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_FormReportFormatOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FormReportFormatOptions] ADD  CONSTRAINT [DF_FormReportFormatOptions_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[FormReportFormatOptions]  WITH CHECK ADD  CONSTRAINT [FK_FormReportFormatOptions_FormReportFormatOptions] FOREIGN KEY([IdCustomAttribute])
REFERENCES [dbo].[CustomAttribute] ([Id])
ALTER TABLE [dbo].[FormReportFormatOptions] CHECK CONSTRAINT [FK_FormReportFormatOptions_FormReportFormatOptions]
