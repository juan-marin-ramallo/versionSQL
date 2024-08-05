/****** Object:  UserDefinedTableType [dbo].[PersonOfInterestTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[PersonOfInterestTableType] AS TABLE(
	[Id] [varchar](20) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[MobilePhoneNumber] [varchar](20) NOT NULL,
	[MobileIMEI] [varchar](40) NOT NULL,
	[Email] [varchar](255) NULL,
	[ProfileCode] [char](1) NULL,
	[ProvinceId] [int] NULL,
	PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
