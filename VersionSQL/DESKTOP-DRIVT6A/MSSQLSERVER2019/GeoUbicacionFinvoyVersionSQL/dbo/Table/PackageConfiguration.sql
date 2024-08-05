/****** Object:  Table [dbo].[PackageConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PackageConfiguration](
	[Id] [smallint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Value] [int] NOT NULL,
	[ErrorMessage] [varchar](200) NOT NULL,
 CONSTRAINT [PK_PackageConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
