/****** Object:  Table [dbo].[MobileScript]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MobileScript](
	[Id] [int] NOT NULL,
	[Name] [varchar](64) NOT NULL,
 CONSTRAINT [PK_MobileScript] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
