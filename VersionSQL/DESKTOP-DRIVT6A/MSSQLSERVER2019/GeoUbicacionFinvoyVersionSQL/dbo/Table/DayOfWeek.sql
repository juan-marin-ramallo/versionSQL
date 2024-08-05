/****** Object:  Table [dbo].[DayOfWeek]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DayOfWeek](
	[Id] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](10) NOT NULL,
	[Order] [smallint] NOT NULL,
 CONSTRAINT [PK_DayOfWeek] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
