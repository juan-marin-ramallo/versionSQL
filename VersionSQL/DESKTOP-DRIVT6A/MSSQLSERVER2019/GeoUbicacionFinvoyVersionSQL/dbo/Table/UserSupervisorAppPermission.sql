/****** Object:  Table [dbo].[UserSupervisorAppPermission]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[UserSupervisorAppPermission](
	[IdUser] [int] NOT NULL,
	[IdSupervisorAppPermission] [int] NOT NULL,
 CONSTRAINT [PK_UserSupervisorAppPermission] PRIMARY KEY CLUSTERED 
(
	[IdUser] ASC,
	[IdSupervisorAppPermission] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
