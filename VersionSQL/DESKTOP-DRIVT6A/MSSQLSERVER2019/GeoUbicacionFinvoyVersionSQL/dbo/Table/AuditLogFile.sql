/****** Object:  Table [dbo].[AuditLogFile]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AuditLogFile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdAuditLog] [int] NOT NULL,
	[RequestName] [varchar](100) NULL,
	[FileName] [varchar](100) NOT NULL,
	[Url] [varchar](2000) NOT NULL,
 CONSTRAINT [PK_AuditLogFile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AuditLogFile]  WITH CHECK ADD  CONSTRAINT [FK_AuditLogFile_AuditLog] FOREIGN KEY([IdAuditLog])
REFERENCES [dbo].[AuditLog] ([Id])
ALTER TABLE [dbo].[AuditLogFile] CHECK CONSTRAINT [FK_AuditLogFile_AuditLog]
