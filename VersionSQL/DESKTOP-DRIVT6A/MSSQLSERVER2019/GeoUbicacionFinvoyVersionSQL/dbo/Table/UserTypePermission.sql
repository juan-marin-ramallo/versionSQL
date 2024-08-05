/****** Object:  Table [dbo].[UserTypePermission]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[UserTypePermission](
	[IdUserType] [int] NOT NULL,
	[IdPermission] [smallint] NOT NULL,
	[View] [bit] NULL,
	[Edit] [bit] NULL,
	[ViewAll] [bit] NULL,
 CONSTRAINT [PK_UserTypePermission] PRIMARY KEY CLUSTERED 
(
	[IdUserType] ASC,
	[IdPermission] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UserTypePermission]  WITH CHECK ADD  CONSTRAINT [FK_UserTypePermission_Permission] FOREIGN KEY([IdPermission])
REFERENCES [dbo].[Permission] ([Id])
ALTER TABLE [dbo].[UserTypePermission] CHECK CONSTRAINT [FK_UserTypePermission_Permission]
ALTER TABLE [dbo].[UserTypePermission]  WITH CHECK ADD  CONSTRAINT [FK_UserTypePermission_UserType] FOREIGN KEY([IdUserType])
REFERENCES [dbo].[UserType] ([Id])
ALTER TABLE [dbo].[UserTypePermission] CHECK CONSTRAINT [FK_UserTypePermission_UserType]
