/****** Object:  Table [dbo].[PersonOfInterestPermission]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterestPermission](
	[Id] [int] NOT NULL,
	[Description] [varchar](128) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[PermissionSet] [nvarchar](25) NULL,
	[Order] [int] NULL,
	[ScheduleProfileSelection] [bit] NOT NULL,
	[CatalogPointAssignation] [bit] NOT NULL,
 CONSTRAINT [PK_PersonOfInterestPermission] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PersonOfInterestPermission] ADD  CONSTRAINT [DF_PersonOfInterestPermission_Enabled]  DEFAULT ((1)) FOR [Enabled]
ALTER TABLE [dbo].[PersonOfInterestPermission] ADD  CONSTRAINT [DF_PersonOfInterestPermission_ScheduleProfileSelection]  DEFAULT ((0)) FOR [ScheduleProfileSelection]
ALTER TABLE [dbo].[PersonOfInterestPermission] ADD  CONSTRAINT [DF_PersonOfInterestPermission_CatalogPointAssignation]  DEFAULT ((0)) FOR [CatalogPointAssignation]
