/****** Object:  UserDefinedTableType [dbo].[OrderStatusDocumentTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[OrderStatusDocumentTableType] AS TABLE(
	[IdStatus] [int] NOT NULL,
	[IdType] [int] NOT NULL,
	[Comment] [varchar](4096) NULL,
	[ImageName] [varchar](256) NULL,
	[ImageUrl] [varchar](2048) NULL
)
