/****** Object:  Table [dbo].[Zone]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Zone](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[Date] [datetime] NULL,
	[ApplyToAllPointOfInterest] [bit] NULL,
	[ApplyToAllPersonOfInterest] [bit] NULL,
 CONSTRAINT [PK_Zone] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
