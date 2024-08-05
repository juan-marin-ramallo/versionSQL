/****** Object:  Table [dbo].[Notification]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Notification](
	[Code] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Subject] [varchar](100) NULL,
	[Template] [varchar](100) NULL,
	[TemplateExcel] [varchar](100) NULL,
	[IdPermission] [smallint] NULL,
	[Description] [varchar](500) NULL,
	[IdPersonPermission] [int] NULL,
	[Visible] [bit] NOT NULL,
	[IdConfiguration] [int] NULL,
 CONSTRAINT [PK_Notification] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Notification] ADD  CONSTRAINT [DF_Notification_IdPersonPermission]  DEFAULT (NULL) FOR [IdPersonPermission]
ALTER TABLE [dbo].[Notification] ADD  CONSTRAINT [DF_Notification_Visible]  DEFAULT ((1)) FOR [Visible]
ALTER TABLE [dbo].[Notification]  WITH CHECK ADD  CONSTRAINT [FK_Notification_Configuration] FOREIGN KEY([IdConfiguration])
REFERENCES [dbo].[Configuration] ([Id])
ALTER TABLE [dbo].[Notification] CHECK CONSTRAINT [FK_Notification_Configuration]
ALTER TABLE [dbo].[Notification]  WITH CHECK ADD  CONSTRAINT [FK_Notification_Notification] FOREIGN KEY([IdPermission])
REFERENCES [dbo].[Permission] ([Id])
ALTER TABLE [dbo].[Notification] CHECK CONSTRAINT [FK_Notification_Notification]
