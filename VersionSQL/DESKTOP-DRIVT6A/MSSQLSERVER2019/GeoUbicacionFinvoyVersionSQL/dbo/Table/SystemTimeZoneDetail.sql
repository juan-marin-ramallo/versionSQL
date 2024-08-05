/****** Object:  Table [dbo].[SystemTimeZoneDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[SystemTimeZoneDetail](
	[OffsetMinutes] [smallint] NOT NULL,
	[UtcStart] [datetime2](0) NOT NULL,
	[UtcEnd] [datetime2](0) NOT NULL,
	[LocalStart] [datetime2](0) NOT NULL,
	[LocalEnd] [datetime2](0) NOT NULL
) ON [PRIMARY]
