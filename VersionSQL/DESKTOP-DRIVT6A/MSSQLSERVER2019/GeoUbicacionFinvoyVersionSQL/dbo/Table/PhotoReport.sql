/****** Object:  Table [dbo].[PhotoReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PhotoReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonOfInterest] [int] NULL,
	[IdPointOfInterest] [int] NULL,
	[ReportDate] [datetime] NULL,
	[ReceivedDate] [datetime] NULL,
	[Comments] [varchar](1000) NULL,
	[ImageEncoded1] [varbinary](max) NULL,
	[ImageEncoded2] [varbinary](max) NULL,
	[CommentsAfter] [varchar](1000) NULL,
	[ImageEncoded1After] [varbinary](max) NULL,
	[ImageEncoded2After] [varbinary](max) NULL,
	[ImageName1] [varchar](100) NULL,
	[ImageUrl1] [varchar](5000) NULL,
	[ImageName2] [varchar](100) NULL,
	[ImageUrl2] [varchar](5000) NULL,
	[ImageName1After] [varchar](100) NULL,
	[ImageUrl1After] [varchar](5000) NULL,
	[ImageName2After] [varchar](100) NULL,
	[ImageUrl2After] [varchar](5000) NULL,
 CONSTRAINT [PK_PhotoReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[PhotoReport]  WITH CHECK ADD  CONSTRAINT [FK_PhotoReport_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[PhotoReport] CHECK CONSTRAINT [FK_PhotoReport_PersonOfInterest]
ALTER TABLE [dbo].[PhotoReport]  WITH CHECK ADD  CONSTRAINT [FK_PhotoReport_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[PhotoReport] CHECK CONSTRAINT [FK_PhotoReport_PointOfInterest]
