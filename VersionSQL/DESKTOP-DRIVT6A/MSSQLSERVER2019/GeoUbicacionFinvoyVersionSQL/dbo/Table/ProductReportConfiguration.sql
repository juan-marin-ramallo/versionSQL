/****** Object:  Table [dbo].[ProductReportConfiguration]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductReportConfiguration](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ShowInProductReport] [bit] NOT NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_ProductReportConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductReportConfiguration] ADD  CONSTRAINT [DF_ProductReportConfiguration_ShowInProductReport]  DEFAULT ((1)) FOR [ShowInProductReport]
