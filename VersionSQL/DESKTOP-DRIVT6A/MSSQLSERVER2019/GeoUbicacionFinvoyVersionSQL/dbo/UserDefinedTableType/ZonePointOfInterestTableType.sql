/****** Object:  UserDefinedTableType [dbo].[ZonePointOfInterestTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ZonePointOfInterestTableType] AS TABLE(
	[PointOfInterestIdentifier] [varchar](50) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[PointOfInterestIdentifier] ASC
)WITH (IGNORE_DUP_KEY = ON)
)
