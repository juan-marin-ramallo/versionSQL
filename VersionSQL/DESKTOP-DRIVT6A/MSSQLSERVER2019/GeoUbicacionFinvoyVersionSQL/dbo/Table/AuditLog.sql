/****** Object:  Table [dbo].[AuditLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AuditLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdUser] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Entity] [int] NOT NULL,
	[Action] [int] NOT NULL,
	[ControllerName] [varchar](50) NOT NULL,
	[ActionName] [varchar](100) NOT NULL,
	[ResultData] [varchar](max) NULL,
	[RequestData] [varchar](max) NULL,
 CONSTRAINT [PK_AuditLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[AuditLog]  WITH NOCHECK ADD  CONSTRAINT [FK_AuditLog_AuditedAction] FOREIGN KEY([Action])
REFERENCES [dbo].[AuditedAction] ([Id])
ALTER TABLE [dbo].[AuditLog] CHECK CONSTRAINT [FK_AuditLog_AuditedAction]
ALTER TABLE [dbo].[AuditLog]  WITH NOCHECK ADD  CONSTRAINT [FK_AuditLog_AuditedEntity] FOREIGN KEY([Entity])
REFERENCES [dbo].[AuditedEntity] ([Id])
ALTER TABLE [dbo].[AuditLog] CHECK CONSTRAINT [FK_AuditLog_AuditedEntity]
ALTER TABLE [dbo].[AuditLog]  WITH CHECK ADD  CONSTRAINT [FK_AuditLog_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[AuditLog] CHECK CONSTRAINT [FK_AuditLog_User]
