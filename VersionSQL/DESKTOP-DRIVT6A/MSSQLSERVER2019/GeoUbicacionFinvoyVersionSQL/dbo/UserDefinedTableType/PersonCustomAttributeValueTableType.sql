/****** Object:  UserDefinedTableType [dbo].[PersonCustomAttributeValueTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[PersonCustomAttributeValueTableType] AS TABLE(
	[IdPersonCustomAttribute] [int] NOT NULL,
	[Value] [varchar](255) NULL,
	[PersonOfInterestIdentifier] [varchar](20) NULL
)
