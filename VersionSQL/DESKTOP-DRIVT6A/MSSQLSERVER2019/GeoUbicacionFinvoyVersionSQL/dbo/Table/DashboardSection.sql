/****** Object:  Table [dbo].[DashboardSection]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DashboardSection](
	[Id] [int] NOT NULL,
	[Name] [varchar](128) NOT NULL,
	[Description] [varchar](4096) NULL,
	[ImageName] [varchar](256) NULL,
	[IdPermission] [smallint] NULL,
	[PartialView] [varchar](256) NOT NULL,
 CONSTRAINT [PK_DashboardSection] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DashboardSection]  WITH CHECK ADD  CONSTRAINT [FK_DashboardSection_Permission] FOREIGN KEY([IdPermission])
REFERENCES [dbo].[Permission] ([Id])
ALTER TABLE [dbo].[DashboardSection] CHECK CONSTRAINT [FK_DashboardSection_Permission]
