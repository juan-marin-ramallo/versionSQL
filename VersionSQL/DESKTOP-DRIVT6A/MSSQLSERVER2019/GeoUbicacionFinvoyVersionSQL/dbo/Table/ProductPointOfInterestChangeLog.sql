/****** Object:  Table [dbo].[ProductPointOfInterestChangeLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductPointOfInterestChangeLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPointOfInterest] [int] NULL,
	[LastUpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_ProductPointOfInterestChangeLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductPointOfInterestChangeLog]  WITH CHECK ADD  CONSTRAINT [FK_ProductPointOfInterestChangeLog_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[ProductPointOfInterestChangeLog] CHECK CONSTRAINT [FK_ProductPointOfInterestChangeLog_PointOfInterest]
