/****** Object:  Table [dbo].[PersonOfInterestType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterestType](
	[Code] [char](1) NOT NULL,
	[Description] [varchar](20) NOT NULL,
	[IdTimeZone] [varchar](50) NULL,
 CONSTRAINT [PK_StockerType] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
