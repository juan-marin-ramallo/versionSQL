/****** Object:  Table [dbo].[UserZone]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[UserZone](
	[IdZone] [int] NOT NULL,
	[IdUser] [int] NOT NULL,
 CONSTRAINT [PK_UserZone] PRIMARY KEY CLUSTERED 
(
	[IdZone] ASC,
	[IdUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UserZone]  WITH NOCHECK ADD  CONSTRAINT [FK_UserZone_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[UserZone] CHECK CONSTRAINT [FK_UserZone_User]
ALTER TABLE [dbo].[UserZone]  WITH NOCHECK ADD  CONSTRAINT [FK_UserZone_Zone] FOREIGN KEY([IdZone])
REFERENCES [dbo].[Zone] ([Id])
ALTER TABLE [dbo].[UserZone] CHECK CONSTRAINT [FK_UserZone_Zone]
