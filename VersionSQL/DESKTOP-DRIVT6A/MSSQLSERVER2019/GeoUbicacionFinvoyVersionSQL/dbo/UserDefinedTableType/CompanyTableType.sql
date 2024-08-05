/****** Object:  UserDefinedTableType [dbo].[CompanyTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[CompanyTableType] AS TABLE(
	[Id] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](512) NULL,
	[IsMain] [bit] NOT NULL,
	[ImageName] [varchar](256) NULL
)
