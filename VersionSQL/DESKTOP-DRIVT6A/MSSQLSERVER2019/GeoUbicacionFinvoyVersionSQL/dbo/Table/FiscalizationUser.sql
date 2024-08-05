/****** Object:  Table [dbo].[FiscalizationUser]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[FiscalizationUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Email] [varchar](255) NULL,
	[Password] [varchar](150) NULL,
	[PasswordRequestedDate] [datetime] NULL,
	[PasswordExpirationDate] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastLoginDate] [datetime] NULL,
	[LastLoginIp] [varchar](20) NULL,
 CONSTRAINT [PK_FiscalizationUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
