/****** Object:  UserDefinedTableType [dbo].[ShareOfShelfItemProductBrandCoordinatesTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ShareOfShelfItemProductBrandCoordinatesTableType] AS TABLE(
	[IdProductBrand] [int] NOT NULL,
	[X0] [int] NULL,
	[Y0] [int] NULL,
	[X1] [int] NULL,
	[Y1] [int] NULL
)
