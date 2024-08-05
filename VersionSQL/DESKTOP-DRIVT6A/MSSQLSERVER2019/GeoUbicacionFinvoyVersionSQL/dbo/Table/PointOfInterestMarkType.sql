/****** Object:  Table [dbo].[PointOfInterestMarkType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PointOfInterestMarkType](
	[Code] [varchar](5) NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_PointOfInterestMarkType] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
