/****** Object:  Table [dbo].[ReportProperyToInclude]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ReportProperyToInclude](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Class] [varchar](100) NOT NULL,
	[Property] [varchar](100) NOT NULL,
 CONSTRAINT [PK_ReportProperyToInclude] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
