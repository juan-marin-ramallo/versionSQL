/****** Object:  UserDefinedTableType [dbo].[AssetPointOfInterestTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[AssetPointOfInterestTableType] AS TABLE(
	[PointOfInterestId] [varchar](50) NOT NULL,
	[AssetId] [varchar](50) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[PointOfInterestId] ASC,
	[AssetId] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
