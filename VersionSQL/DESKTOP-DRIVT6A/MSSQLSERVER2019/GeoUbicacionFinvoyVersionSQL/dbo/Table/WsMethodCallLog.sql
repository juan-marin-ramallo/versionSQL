/****** Object:  Table [dbo].[WsMethodCallLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[WsMethodCallLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[MethodName] [varchar](200) NOT NULL,
	[MethodParameters] [varchar](max) NULL,
 CONSTRAINT [PK_WsMethodCallLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
