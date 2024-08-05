/****** Object:  Table [dbo].[PowerBIBoard]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PowerBIBoard](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPowerBIConfiguration] [int] NOT NULL,
	[BoardId] [varchar](100) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
	[IdPermission] [smallint] NOT NULL,
	[IconUrl] [varchar](2000) NOT NULL,
	[ShowOnReportsPage] [bit] NOT NULL,
 CONSTRAINT [PK_PowerBIBoard_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PowerBIBoard] ADD  CONSTRAINT [DF_PowerBIBoard_ShowOnReportsPage]  DEFAULT ((1)) FOR [ShowOnReportsPage]
ALTER TABLE [dbo].[PowerBIBoard]  WITH CHECK ADD  CONSTRAINT [FK_PowerBIBoard_IdPermission] FOREIGN KEY([IdPermission])
REFERENCES [dbo].[Permission] ([Id])
ALTER TABLE [dbo].[PowerBIBoard] CHECK CONSTRAINT [FK_PowerBIBoard_IdPermission]
ALTER TABLE [dbo].[PowerBIBoard]  WITH CHECK ADD  CONSTRAINT [FK_PowerBIBoard_IdPowerBIConfiguration] FOREIGN KEY([IdPowerBIConfiguration])
REFERENCES [dbo].[PowerBIConfiguration] ([Id])
ALTER TABLE [dbo].[PowerBIBoard] CHECK CONSTRAINT [FK_PowerBIBoard_IdPowerBIConfiguration]
