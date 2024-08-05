/****** Object:  Table [dbo].[FilePersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[FilePersonOfInterest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdFile] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[Received] [bit] NOT NULL,
	[ReceivedDate] [datetime] NULL,
	[Read] [bit] NOT NULL,
	[ReadDate] [datetime] NULL,
 CONSTRAINT [PK_DocumentPersonOfInterest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FilePersonOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_DocumentPersonOfInterest_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[FilePersonOfInterest] CHECK CONSTRAINT [FK_DocumentPersonOfInterest_PersonOfInterest]
ALTER TABLE [dbo].[FilePersonOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_FilePersonOfInterest_File] FOREIGN KEY([IdFile])
REFERENCES [dbo].[File] ([Id])
ALTER TABLE [dbo].[FilePersonOfInterest] CHECK CONSTRAINT [FK_FilePersonOfInterest_File]
