/****** Object:  UserDefinedTableType [dbo].[ProductBrandTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ProductBrandTableType] AS TABLE(
	[IdCompany] [varchar](50) NOT NULL,
	[Id] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](512) NULL,
	[IdFather] [varchar](50) NULL,
	[ImageName] [varchar](256) NULL
)
