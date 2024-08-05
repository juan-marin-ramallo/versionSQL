/****** Object:  Table [dbo].[Permission]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Permission](
	[Id] [smallint] NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[Order] [smallint] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[ViewEditEnabled] [bit] NOT NULL,
	[ViewAllEnabled] [bit] NOT NULL,
	[ForUsersWithPerson] [bit] NOT NULL,
 CONSTRAINT [PK_Permission] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Permission] ADD  CONSTRAINT [DF_Permission_Order]  DEFAULT ((0)) FOR [Order]
ALTER TABLE [dbo].[Permission] ADD  CONSTRAINT [DF_Permission_ForUsersWithPerson]  DEFAULT ((0)) FOR [ForUsersWithPerson]
