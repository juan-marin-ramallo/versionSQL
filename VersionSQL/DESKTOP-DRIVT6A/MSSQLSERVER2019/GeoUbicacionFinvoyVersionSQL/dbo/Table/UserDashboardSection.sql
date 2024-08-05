/****** Object:  Table [dbo].[UserDashboardSection]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[UserDashboardSection](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdUser] [int] NOT NULL,
	[IdDashboardSection] [int] NOT NULL,
	[Size] [smallint] NOT NULL,
	[Position] [int] NOT NULL,
	[IdDateRange] [smallint] NOT NULL,
 CONSTRAINT [PK_UserDashboardSection] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UserDashboardSection]  WITH CHECK ADD  CONSTRAINT [FK_UserDashboardSection_DashboardSection] FOREIGN KEY([IdDashboardSection])
REFERENCES [dbo].[DashboardSection] ([Id])
ALTER TABLE [dbo].[UserDashboardSection] CHECK CONSTRAINT [FK_UserDashboardSection_DashboardSection]
ALTER TABLE [dbo].[UserDashboardSection]  WITH CHECK ADD  CONSTRAINT [FK_UserDashboardSection_DateRange] FOREIGN KEY([IdDateRange])
REFERENCES [dbo].[DateRange] ([Id])
ALTER TABLE [dbo].[UserDashboardSection] CHECK CONSTRAINT [FK_UserDashboardSection_DateRange]
ALTER TABLE [dbo].[UserDashboardSection]  WITH CHECK ADD  CONSTRAINT [FK_UserDashboardSection_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[UserDashboardSection] CHECK CONSTRAINT [FK_UserDashboardSection_User]
