/****** Object:  Table [dbo].[PowerpointMarkupProductReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PowerpointMarkupProductReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](250) NOT NULL,
	[ShowTitles] [bit] NOT NULL,
 CONSTRAINT [PK_PowerpointMarkupProductReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PowerpointMarkupProductReport] ADD  CONSTRAINT [DF_PowerpointMarkupProductReport_ShowTitles]  DEFAULT ((1)) FOR [ShowTitles]
