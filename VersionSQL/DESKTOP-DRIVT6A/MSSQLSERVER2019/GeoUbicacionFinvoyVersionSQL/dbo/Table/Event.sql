/****** Object:  Table [dbo].[Event]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Event](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[Type] [varchar](10) NOT NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Event]  WITH NOCHECK ADD  CONSTRAINT [FK_Event_EventType] FOREIGN KEY([Type])
REFERENCES [dbo].[EventType] ([Code])
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_EventType]
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_PersonOfInterest]
