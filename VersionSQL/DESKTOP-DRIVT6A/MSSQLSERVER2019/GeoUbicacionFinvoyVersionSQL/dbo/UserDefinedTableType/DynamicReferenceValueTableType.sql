/****** Object:  UserDefinedTableType [dbo].[DynamicReferenceValueTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[DynamicReferenceValueTableType] AS TABLE(
	[ProductBarCode] [varchar](100) NOT NULL,
	[PointOfInterestIdentifier] [varchar](50) NOT NULL,
	[Dynamic] [varchar](100) NOT NULL,
	[Form] [varchar](100) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ReferenceName] [varchar](100) NOT NULL,
	[ReferenceValue] [varchar](1000) NOT NULL
)
