/****** Object:  Table [dbo].[ProductMissingReportTypeOld]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductMissingReportTypeOld](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[Deleted] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[IdUser] [int] NULL,
 CONSTRAINT [PK_ProductMissingReportType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductMissingReportTypeOld] ADD  CONSTRAINT [DF_ProductMissingReportType_Deleted]  DEFAULT ((0)) FOR [Deleted]
