/****** Object:  Table [dbo].[AssetReportAttributeVisibilityType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AssetReportAttributeVisibilityType](
	[Id] [smallint] NOT NULL,
	[Description] [varchar](100) NOT NULL,
 CONSTRAINT [PK_AssetReportAttributeVisibilityType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
