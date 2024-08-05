/****** Object:  UserDefinedTableType [dbo].[WorkActivityTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[WorkActivityTableType] AS TABLE(
	[ActivityDate] [datetime] NOT NULL,
	[ActivityEndDate] [datetime] NULL,
	[PointOfInterestId] [int] NULL,
	[RouteGroupId] [int] NULL,
	[MeetingId] [int] NULL,
	[Description] [varchar](2048) NULL,
	[WorkActivityTypeId] [int] NOT NULL
)
