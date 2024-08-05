/****** Object:  UserDefinedTableType [dbo].[ProductReportAttributeValueTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ProductReportAttributeValueTableType] AS TABLE(
	[Id] [int] NOT NULL,
	[Value] [varchar](max) NULL,
	[IdProductReport] [int] NOT NULL,
	[IdProductReportAttributeOption] [int] NULL,
	[ImageName] [varchar](100) NULL,
	[ImageEncoded] [varbinary](max) NULL,
	[ImageUrl] [varchar](5000) NULL
)
