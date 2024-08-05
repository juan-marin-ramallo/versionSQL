/****** Object:  Table [dbo].[CustomReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[IdType] [int] NULL,
	[IdForm] [int] NULL,
	[TemplateFilename] [varchar](200) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[EditedDate] [datetime] NULL,
	[Deleted] [bit] NOT NULL,
	[IdUser] [int] NULL,
 CONSTRAINT [PK_CustomReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomReport] ADD  CONSTRAINT [DF_CustomReport_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[CustomReport]  WITH CHECK ADD  CONSTRAINT [FK_CustomReport_CustomReport] FOREIGN KEY([IdType])
REFERENCES [dbo].[CustomReportType] ([Id])
ALTER TABLE [dbo].[CustomReport] CHECK CONSTRAINT [FK_CustomReport_CustomReport]
ALTER TABLE [dbo].[CustomReport]  WITH CHECK ADD  CONSTRAINT [FK_CustomReport_Form] FOREIGN KEY([IdForm])
REFERENCES [dbo].[Form] ([Id])
ALTER TABLE [dbo].[CustomReport] CHECK CONSTRAINT [FK_CustomReport_Form]
ALTER TABLE [dbo].[CustomReport]  WITH CHECK ADD  CONSTRAINT [FK_CustomReport_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[CustomReport] CHECK CONSTRAINT [FK_CustomReport_User]
