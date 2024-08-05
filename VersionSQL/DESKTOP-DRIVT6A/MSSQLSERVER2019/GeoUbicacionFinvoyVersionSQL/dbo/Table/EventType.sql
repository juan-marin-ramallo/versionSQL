﻿/****** Object:  Table [dbo].[EventType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[EventType](
	[Code] [varchar](10) NOT NULL,
	[Description] [varchar](250) NOT NULL,
 CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
