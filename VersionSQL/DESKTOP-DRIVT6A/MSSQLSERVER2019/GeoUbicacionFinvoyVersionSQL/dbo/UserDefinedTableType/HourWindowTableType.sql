/****** Object:  UserDefinedTableType [dbo].[HourWindowTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[HourWindowTableType] AS TABLE(
	[Id] [varchar](50) NOT NULL,
	[Day] [smallint] NOT NULL,
	[FromHour] [time](7) NOT NULL,
	[ToHour] [time](7) NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[Day] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
