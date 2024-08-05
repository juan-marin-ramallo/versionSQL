/****** Object:  Table [dbo].[ProductReportOptions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductReportOptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
	[Deleted] [bit] NULL,
 CONSTRAINT [PK_ProductReportOptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
