/****** Object:  Table [dbo].[UserCompany]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[UserCompany](
	[IdUser] [int] NOT NULL,
	[IdCompany] [int] NOT NULL,
 CONSTRAINT [PK_UserCompany] PRIMARY KEY CLUSTERED 
(
	[IdUser] ASC,
	[IdCompany] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UserCompany]  WITH CHECK ADD  CONSTRAINT [FK_UserCompany_Company] FOREIGN KEY([IdCompany])
REFERENCES [dbo].[Company] ([Id])
ALTER TABLE [dbo].[UserCompany] CHECK CONSTRAINT [FK_UserCompany_Company]
ALTER TABLE [dbo].[UserCompany]  WITH CHECK ADD  CONSTRAINT [FK_UserCompany_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[UserCompany] CHECK CONSTRAINT [FK_UserCompany_User]
