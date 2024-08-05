/****** Object:  Table [dbo].[PersonOfInterestTypePermission]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonOfInterestTypePermission](
	[CodePersonOfInterestType] [char](1) NOT NULL,
	[IdPersonOfInterestPermission] [int] NOT NULL,
 CONSTRAINT [PK_PersonOfInterestTypePermission] PRIMARY KEY CLUSTERED 
(
	[CodePersonOfInterestType] ASC,
	[IdPersonOfInterestPermission] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PersonOfInterestTypePermission]  WITH CHECK ADD  CONSTRAINT [FK_PersonOfInterestTypePermission_PersonOfInterestPermission] FOREIGN KEY([IdPersonOfInterestPermission])
REFERENCES [dbo].[PersonOfInterestPermission] ([Id])
ALTER TABLE [dbo].[PersonOfInterestTypePermission] CHECK CONSTRAINT [FK_PersonOfInterestTypePermission_PersonOfInterestPermission]
ALTER TABLE [dbo].[PersonOfInterestTypePermission]  WITH NOCHECK ADD  CONSTRAINT [FK_PersonOfInterestTypePermission_PersonOfInterestType] FOREIGN KEY([CodePersonOfInterestType])
REFERENCES [dbo].[PersonOfInterestType] ([Code])
ALTER TABLE [dbo].[PersonOfInterestTypePermission] CHECK CONSTRAINT [FK_PersonOfInterestTypePermission_PersonOfInterestType]
