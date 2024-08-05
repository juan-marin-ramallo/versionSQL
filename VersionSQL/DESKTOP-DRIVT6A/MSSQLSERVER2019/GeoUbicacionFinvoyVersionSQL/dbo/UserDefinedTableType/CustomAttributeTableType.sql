/****** Object:  UserDefinedTableType [dbo].[CustomAttributeTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[CustomAttributeTableType] AS TABLE(
	[IdCustomAttribute] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[Value] [varchar](max) NULL,
	[IdOption] [int] NULL,
	PRIMARY KEY NONCLUSTERED 
(
	[IdCustomAttribute] ASC,
	[IdPointOfInterest] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
