/****** Object:  Table [dbo].[ParameterType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ParameterType](
	[Id] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Deleted] [bit] NULL,
	[Untouchable] [bit] NULL,
	[Invisible] [bit] NOT NULL,
 CONSTRAINT [PK_ParameterType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ParameterType] ADD  CONSTRAINT [DF_ParameterType_Untochable]  DEFAULT ((0)) FOR [Untouchable]
ALTER TABLE [dbo].[ParameterType] ADD  CONSTRAINT [DF_ParameterType_Invisible]  DEFAULT ((0)) FOR [Invisible]
