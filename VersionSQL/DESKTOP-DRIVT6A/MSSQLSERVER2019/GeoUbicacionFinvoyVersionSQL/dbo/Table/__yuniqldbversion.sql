/****** Object:  Table [dbo].[__yuniqldbversion]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[__yuniqldbversion](
	[SequenceId] [smallint] IDENTITY(1,1) NOT NULL,
	[Version] [nvarchar](512) NOT NULL,
	[AppliedOnUtc] [datetime] NOT NULL,
	[AppliedByUser] [nvarchar](32) NOT NULL,
	[AppliedByTool] [nvarchar](32) NULL,
	[AppliedByToolVersion] [nvarchar](16) NULL,
	[AdditionalArtifacts] [varbinary](max) NULL,
 CONSTRAINT [PK___YuniqlDbVersion] PRIMARY KEY CLUSTERED 
(
	[SequenceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX___YuniqlDbVersion] UNIQUE NONCLUSTERED 
(
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[__yuniqldbversion] ADD  CONSTRAINT [DF___YuniqlDbVersion_AppliedOnUtc]  DEFAULT (getutcdate()) FOR [AppliedOnUtc]
ALTER TABLE [dbo].[__yuniqldbversion] ADD  CONSTRAINT [DF___YuniqlDbVersion_AppliedByUser]  DEFAULT (suser_sname()) FOR [AppliedByUser]
