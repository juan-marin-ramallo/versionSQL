/****** Object:  Table [dbo].[ProductMissingImage]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductMissingImage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdProductMissing] [int] NOT NULL,
	[ImageUrl] [varchar](512) NULL,
	[ImageName] [varchar](256) NOT NULL,
	[ImageRecognitionUrl] [varchar](1000) NULL,
 CONSTRAINT [PK_ProductMissingImage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductMissingImage]  WITH CHECK ADD  CONSTRAINT [FK_ProductMissingImage_IdProductMissing_ProductMissingPointOfInterest_Id] FOREIGN KEY([IdProductMissing])
REFERENCES [dbo].[ProductMissingPointOfInterest] ([Id])
ALTER TABLE [dbo].[ProductMissingImage] CHECK CONSTRAINT [FK_ProductMissingImage_IdProductMissing_ProductMissingPointOfInterest_Id]
