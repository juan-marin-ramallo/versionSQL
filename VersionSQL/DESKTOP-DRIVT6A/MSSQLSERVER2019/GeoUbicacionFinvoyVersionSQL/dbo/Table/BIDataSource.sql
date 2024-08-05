/****** Object:  Table [dbo].[BIDataSource]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[BIDataSource](
	[Id] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[LastReportedDate] [datetime] NOT NULL,
	[StoredProcedure] [varchar](50) NOT NULL,
	[LocalBasePath] [varchar](260) NOT NULL,
 CONSTRAINT [PK_BIDataSource] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
