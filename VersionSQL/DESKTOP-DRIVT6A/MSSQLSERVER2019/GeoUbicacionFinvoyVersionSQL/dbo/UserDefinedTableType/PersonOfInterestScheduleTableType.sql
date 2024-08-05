/****** Object:  UserDefinedTableType [dbo].[PersonOfInterestScheduleTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[PersonOfInterestScheduleTableType] AS TABLE(
	[Id] [varchar](50) NOT NULL,
	[Day] [smallint] NOT NULL,
	[WorkHours] [time](7) NOT NULL,
	[FromHour] [time](7) NOT NULL,
	[ToHour] [time](7) NOT NULL,
	[RestHour] [time](7) NULL,
	PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[Day] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
