/****** Object:  Table [dbo].[MarkValidationType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MarkValidationType](
	[Id] [smallint] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_MarkValidationType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
