/****** Object:  Table [Tzdb].[Intervals]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [Tzdb].[Intervals](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ZoneId] [int] NOT NULL,
	[UtcStart] [datetime2](0) NOT NULL,
	[UtcEnd] [datetime2](0) NOT NULL,
	[LocalStart] [datetime2](0) NOT NULL,
	[LocalEnd] [datetime2](0) NOT NULL,
	[OffsetMinutes] [smallint] NOT NULL,
	[Abbreviation] [varchar](10) NOT NULL,
 CONSTRAINT [PK__Interval__3214EC075E552EC8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Intervals_Local] ON [Tzdb].[Intervals]
(
	[ZoneId] ASC,
	[LocalStart] ASC,
	[LocalEnd] ASC,
	[UtcStart] ASC
)
INCLUDE([Abbreviation],[OffsetMinutes]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Intervals_Utc] ON [Tzdb].[Intervals]
(
	[ZoneId] ASC,
	[UtcStart] ASC,
	[UtcEnd] ASC
)
INCLUDE([Abbreviation],[OffsetMinutes]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [Tzdb].[Intervals]  WITH CHECK ADD  CONSTRAINT [FK_Intervals_Zones] FOREIGN KEY([ZoneId])
REFERENCES [Tzdb].[Zones] ([Id])
ALTER TABLE [Tzdb].[Intervals] CHECK CONSTRAINT [FK_Intervals_Zones]
