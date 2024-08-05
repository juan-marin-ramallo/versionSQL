/****** Object:  Table [dbo].[CurrentLocation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CurrentLocation](
	[IdPersonOfInterest] [int] NOT NULL,
	[IdLocation] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Latitude] [decimal](25, 20) NOT NULL,
	[Longitude] [decimal](25, 20) NOT NULL,
	[Accuracy] [decimal](8, 1) NOT NULL,
	[BatteryLevel] [decimal](5, 2) NOT NULL,
	[LatLong] [geography] NOT NULL,
 CONSTRAINT [PK_CurrentLocation] PRIMARY KEY CLUSTERED 
(
	[IdPersonOfInterest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
