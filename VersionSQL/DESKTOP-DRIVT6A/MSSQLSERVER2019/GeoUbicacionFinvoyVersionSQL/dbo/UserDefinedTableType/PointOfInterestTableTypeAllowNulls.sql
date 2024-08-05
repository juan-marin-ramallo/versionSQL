/****** Object:  UserDefinedTableType [dbo].[PointOfInterestTableTypeAllowNulls]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[PointOfInterestTableTypeAllowNulls] AS TABLE(
	[Id] [varchar](50) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Address] [varchar](250) NULL,
	[Latitude] [decimal](25, 20) NULL,
	[Longitude] [decimal](25, 20) NULL,
	[Radius] [int] NULL,
	[MinElapsedTimeForVisit] [int] NULL,
	[ProvinceId] [int] NULL,
	[ContactName] [varchar](50) NULL,
	[ContactPhoneNumber] [varchar](50) NULL,
	[NFCTagId] [varchar](50) NULL,
	[HierarchyLevel1Id] [varchar](100) NULL,
	[HierarchyLevel2Id] [varchar](100) NULL,
	[Emails] [varchar](1000) NULL,
	[Zones] [varchar](5000) NULL,
	PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
