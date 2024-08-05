/****** Object:  Table [dbo].[SynchronizationType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[SynchronizationType](
	[Code] [smallint] NOT NULL,
	[Text] [varchar](128) NOT NULL,
 CONSTRAINT [PK_SynchronizationType] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
