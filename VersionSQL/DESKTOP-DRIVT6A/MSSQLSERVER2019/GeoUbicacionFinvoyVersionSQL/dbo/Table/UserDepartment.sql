/****** Object:  Table [dbo].[UserDepartment]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[UserDepartment](
	[IdUser] [int] NOT NULL,
	[IdDepartment] [int] NOT NULL,
 CONSTRAINT [PK_UserDepartment] PRIMARY KEY CLUSTERED 
(
	[IdUser] ASC,
	[IdDepartment] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UserDepartment]  WITH NOCHECK ADD  CONSTRAINT [FK_UserDepartment_Department] FOREIGN KEY([IdDepartment])
REFERENCES [dbo].[Department] ([Id])
ALTER TABLE [dbo].[UserDepartment] CHECK CONSTRAINT [FK_UserDepartment_Department]
ALTER TABLE [dbo].[UserDepartment]  WITH NOCHECK ADD  CONSTRAINT [FK_UserDepartment_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[UserDepartment] CHECK CONSTRAINT [FK_UserDepartment_User]
