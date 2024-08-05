/****** Object:  UserDefinedTableType [dbo].[POIHierarchyTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[POIHierarchyTableType] AS TABLE(
	[Id] [varchar](100) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Society] [varchar](4) NULL,
	[GroupId] [varchar](100) NULL,
	PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
