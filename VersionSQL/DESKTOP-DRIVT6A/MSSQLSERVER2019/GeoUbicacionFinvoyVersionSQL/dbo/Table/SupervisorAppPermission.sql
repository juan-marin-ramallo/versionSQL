/****** Object:  Table [dbo].[SupervisorAppPermission]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[SupervisorAppPermission](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[Order] [smallint] NOT NULL,
	[Enabled] [bit] NOT NULL,
 CONSTRAINT [PK_SupervisorAppPermission] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SupervisorAppPermission] ADD  CONSTRAINT [DF_SupervisorAppPermission_Enabled]  DEFAULT ((1)) FOR [Enabled]
