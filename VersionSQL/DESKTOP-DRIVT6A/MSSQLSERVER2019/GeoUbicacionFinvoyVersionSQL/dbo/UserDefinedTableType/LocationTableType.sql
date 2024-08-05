/****** Object:  UserDefinedTableType [dbo].[LocationTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[LocationTableType] AS TABLE(
	[IdPersonOfInterest] [int] NULL,
	[Date] [datetime] NULL,
	[Latitude] [decimal](25, 20) NULL,
	[Longitude] [decimal](25, 20) NULL,
	[Accuracy] [decimal](8, 1) NULL,
	[BatteryLevel] [decimal](5, 2) NULL,
	[LatLong] [geography] NULL
)
