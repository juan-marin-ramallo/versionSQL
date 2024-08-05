/****** Object:  UserDefinedTableType [dbo].[IdMicrosoftIdTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[IdMicrosoftIdTableType] AS TABLE(
	[Id] [int] NULL,
	[MeetingId] [int] NULL,
	[MicrosoftId] [varchar](2048) NULL
)
