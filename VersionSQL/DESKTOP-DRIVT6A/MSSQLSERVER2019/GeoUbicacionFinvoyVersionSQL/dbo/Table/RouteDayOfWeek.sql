/****** Object:  Table [dbo].[RouteDayOfWeek]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[RouteDayOfWeek](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdRoutePointOfInterest] [int] NOT NULL,
	[DayOfWeek] [int] NOT NULL,
 CONSTRAINT [PK_RouteDayOfWeek] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RouteDayOfWeek]  WITH CHECK ADD  CONSTRAINT [FK_RouteDayOfWeek_Route] FOREIGN KEY([IdRoutePointOfInterest])
REFERENCES [dbo].[RoutePointOfInterest] ([Id])
ALTER TABLE [dbo].[RouteDayOfWeek] CHECK CONSTRAINT [FK_RouteDayOfWeek_Route]
