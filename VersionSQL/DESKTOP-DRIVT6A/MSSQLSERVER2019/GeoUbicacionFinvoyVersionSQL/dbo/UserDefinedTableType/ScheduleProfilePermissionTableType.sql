/****** Object:  UserDefinedTableType [dbo].[ScheduleProfilePermissionTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[ScheduleProfilePermissionTableType] AS TABLE(
	[IdPersonOfInterestPermission] [int] NOT NULL,
	[LimitOnlyOnce] [bit] NOT NULL
)
