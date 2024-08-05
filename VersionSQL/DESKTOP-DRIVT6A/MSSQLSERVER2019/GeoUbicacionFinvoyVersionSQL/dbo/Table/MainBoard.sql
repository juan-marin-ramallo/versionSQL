/****** Object:  Table [dbo].[MainBoard]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MainBoard](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
	[Order] [smallint] NOT NULL,
	[IdPermission] [smallint] NOT NULL,
	[IconUrl] [varchar](1000) NOT NULL,
	[ActionUrl] [varchar](200) NOT NULL,
 CONSTRAINT [PK_MainBoard_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MainBoard]  WITH CHECK ADD  CONSTRAINT [FK_MainBoard_IdPermission] FOREIGN KEY([IdPermission])
REFERENCES [dbo].[Permission] ([Id])
ALTER TABLE [dbo].[MainBoard] CHECK CONSTRAINT [FK_MainBoard_IdPermission]
