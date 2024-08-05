/****** Object:  Table [dbo].[RouteGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[RouteGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[EditedDate] [datetime] NULL,
	[Deleted] [bit] NULL,
 CONSTRAINT [PK_RouteGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RouteGroup]  WITH CHECK ADD  CONSTRAINT [FK_RouteGroup_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[RouteGroup] CHECK CONSTRAINT [FK_RouteGroup_PersonOfInterest]
