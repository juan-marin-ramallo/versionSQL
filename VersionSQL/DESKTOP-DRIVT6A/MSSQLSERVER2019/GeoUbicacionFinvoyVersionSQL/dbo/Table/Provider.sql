/****** Object:  Table [dbo].[Provider]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Provider](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[SapId] [varchar](18) NOT NULL,
	[Society] [varchar](4) NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Provider] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Provider] ADD  CONSTRAINT [DF_Provider_Deleted]  DEFAULT ((0)) FOR [Deleted]
