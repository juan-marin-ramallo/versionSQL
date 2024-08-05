/****** Object:  Table [dbo].[RouteWebNoVisitOption]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[RouteWebNoVisitOption](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](500) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[IdUser] [int] NULL,
	[Deleted] [bit] NULL,
	[EditedDate] [datetime] NULL,
 CONSTRAINT [PK_RouteWebNoVisitOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RouteWebNoVisitOption]  WITH CHECK ADD  CONSTRAINT [FK_RouteWebNoVisitOption_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[RouteWebNoVisitOption] CHECK CONSTRAINT [FK_RouteWebNoVisitOption_User]
