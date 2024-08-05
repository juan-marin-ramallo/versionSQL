/****** Object:  Table [dbo].[WorkPlan]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[WorkPlan](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[ApprovedState] [smallint] NOT NULL,
	[ApprovingUserId] [int] NULL,
	[ApprovedDate] [datetime] NULL,
	[ApprovedReason] [nvarchar](250) NULL,
	[IdUser] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[IdRouteGroup] [int] NULL,
 CONSTRAINT [PK_WorkPlan] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[WorkPlan] ADD  CONSTRAINT [DF_WorkPlan_ApprovedState]  DEFAULT ((2)) FOR [ApprovedState]
