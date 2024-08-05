/****** Object:  UserDefinedTableType [dbo].[PersonOfInterestFiscalizationInfoTableType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TYPE [dbo].[PersonOfInterestFiscalizationInfoTableType] AS TABLE(
	[Id] [varchar](50) NOT NULL,
	[IsOutsourced] [bit] NOT NULL,
	[PlaceOfWorkIdentifier] [varchar](50) NULL,
	[HasSplittedWorkHours] [bit] NOT NULL,
	[SplittedWorkHoursResolutionNumber] [varchar](50) NULL,
	[WorkOnSundays] [bit] NOT NULL
)
