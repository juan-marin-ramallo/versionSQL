/****** Object:  UserDefinedTableType [dbo].[ZonePersonOfInterestTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ZonePersonOfInterestTableType] AS TABLE(
	[PersonOfInterestIdentifier] [varchar](20) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[PersonOfInterestIdentifier] ASC
)WITH (IGNORE_DUP_KEY = ON)
)
