/****** Object:  Table [dbo].[RouteNoVisitOption]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[RouteNoVisitOption](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[IdUser] [int] NULL,
	[Deleted] [bit] NULL,
	[EditedDate] [datetime] NULL,
 CONSTRAINT [PK_RouteNoVisitOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RouteNoVisitOption]  WITH CHECK ADD  CONSTRAINT [FK_RouteNoVisitOption_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[RouteNoVisitOption] CHECK CONSTRAINT [FK_RouteNoVisitOption_User]
