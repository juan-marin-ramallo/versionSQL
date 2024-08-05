/****** Object:  Table [Tzdb].[VersionInfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [Tzdb].[VersionInfo](
	[Version] [char](5) NOT NULL,
	[Loaded] [datetimeoffset](0) NOT NULL,
 CONSTRAINT [PK__VersionI__0F54013590D0C3AD] PRIMARY KEY CLUSTERED 
(
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
