/****** Object:  UserDefinedTableType [dbo].[ProductDynamicTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ProductDynamicTableType] AS TABLE(
	[ProductBarCode] [varchar](100) NOT NULL,
	[PointOfInterestIdentifier] [varchar](50) NOT NULL,
	[Dynamic] [varchar](100) NOT NULL,
	[Action] [char](1) NOT NULL,
	[SectionOrForm] [varchar](100) NOT NULL
)
