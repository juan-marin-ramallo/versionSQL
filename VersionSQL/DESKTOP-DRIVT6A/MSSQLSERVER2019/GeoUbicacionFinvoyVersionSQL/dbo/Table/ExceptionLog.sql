/****** Object:  Table [dbo].[ExceptionLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ExceptionLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[AssemblyName] [varchar](150) NOT NULL,
	[ClassName] [varchar](100) NOT NULL,
	[MethodName] [varchar](200) NOT NULL,
	[ExceptionMessage] [varchar](500) NULL,
	[ExceptionDetails] [varchar](8000) NULL,
 CONSTRAINT [PK_ExceptionLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
