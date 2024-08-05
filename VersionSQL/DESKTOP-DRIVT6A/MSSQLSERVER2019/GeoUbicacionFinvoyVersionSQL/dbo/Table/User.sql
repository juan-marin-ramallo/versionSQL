/****** Object:  Table [dbo].[User]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[Email] [varchar](255) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Password] [varchar](150) NOT NULL,
	[FirstTimeLogin] [bit] NOT NULL,
	[Type] [int] NULL,
	[Status] [char](1) NOT NULL,
	[SuperAdmin] [bit] NOT NULL,
	[ChangePassword] [bit] NULL,
	[IdPersonOfInterest] [int] NULL,
	[AppUserStatus] [char](1) NOT NULL,
	[CreatedAtKioskMode] [bit] NOT NULL,
	[MicrosoftAccessToken] [varchar](2048) NULL,
	[MicrosoftAccessTokenExpiration] [datetime] NULL,
	[MicrosoftRefreshToken] [varchar](2048) NULL,
	[MicrosoftCalendarId] [varchar](2048) NULL,
	[LastLoginDate] [datetime] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_email_user] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_Type]  DEFAULT ((0)) FOR [Type]
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_AppUserStatus]  DEFAULT ('D') FOR [AppUserStatus]
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_CreatedAtKioskMode]  DEFAULT ((0)) FOR [CreatedAtKioskMode]
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_MicrosoftAccessToken]  DEFAULT (NULL) FOR [MicrosoftAccessToken]
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_PersonOfInterest]
ALTER TABLE [dbo].[User]  WITH NOCHECK ADD  CONSTRAINT [FK_User_Status] FOREIGN KEY([Status])
REFERENCES [dbo].[Status] ([Code])
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_Status]
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_Status_SupApp] FOREIGN KEY([AppUserStatus])
REFERENCES [dbo].[Status] ([Code])
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_Status_SupApp]
