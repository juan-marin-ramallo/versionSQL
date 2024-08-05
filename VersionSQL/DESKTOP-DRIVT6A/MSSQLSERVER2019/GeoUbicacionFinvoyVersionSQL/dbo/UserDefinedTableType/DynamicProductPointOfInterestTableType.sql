/****** Object:  UserDefinedTableType [dbo].[DynamicProductPointOfInterestTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[DynamicProductPointOfInterestTableType] AS TABLE(
	[ProductBarCode] [varchar](100) NOT NULL,
	[PointOfInterestIdentifier] [varchar](50) NOT NULL,
	[Dynamic] [varchar](100) NOT NULL,
	[Form] [varchar](100) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL
)
