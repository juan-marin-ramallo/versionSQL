/****** Object:  Table [dbo].[AppVersion]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AppVersion](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Version] [varchar](10) NULL,
	[TerminalVersion] [varchar](10) NULL,
 CONSTRAINT [PK_AppVersion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
