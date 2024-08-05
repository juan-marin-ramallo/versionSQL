/****** Object:  Table [dbo].[DateRange]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DateRange](
	[Id] [smallint] NOT NULL,
	[Name] [varchar](128) NOT NULL,
	[DatePart] [varchar](16) NOT NULL,
	[Number] [smallint] NOT NULL,
	[FromBeginning] [bit] NOT NULL,
	[ToEnd] [bit] NOT NULL,
	[DisplayOrder] [smallint] NOT NULL,
 CONSTRAINT [PK_DateRange] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
