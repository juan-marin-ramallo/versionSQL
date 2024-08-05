/****** Object:  Table [Tzdb].[Links]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [Tzdb].[Links](
	[LinkZoneId] [int] NOT NULL,
	[CanonicalZoneId] [int] NOT NULL,
 CONSTRAINT [PK__Links__FF7285C024A26F8E] PRIMARY KEY CLUSTERED 
(
	[LinkZoneId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [Tzdb].[Links]  WITH CHECK ADD  CONSTRAINT [FK_Links_Zones_1] FOREIGN KEY([LinkZoneId])
REFERENCES [Tzdb].[Zones] ([Id])
ALTER TABLE [Tzdb].[Links] CHECK CONSTRAINT [FK_Links_Zones_1]
ALTER TABLE [Tzdb].[Links]  WITH CHECK ADD  CONSTRAINT [FK_Links_Zones_2] FOREIGN KEY([CanonicalZoneId])
REFERENCES [Tzdb].[Zones] ([Id])
ALTER TABLE [Tzdb].[Links] CHECK CONSTRAINT [FK_Links_Zones_2]
