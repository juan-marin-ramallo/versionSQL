/****** Object:  Table [dbo].[ShareOfShelfImage]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ShareOfShelfImage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdShareOfShelf] [int] NOT NULL,
	[ImageUrl] [varchar](512) NULL,
	[ImageName] [varchar](256) NOT NULL,
	[ImageRecognitionUrl] [varchar](1000) NULL,
 CONSTRAINT [PK_ShareOfShelfImage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ShareOfShelfImage]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfImage_ShareOfShelfReport] FOREIGN KEY([IdShareOfShelf])
REFERENCES [dbo].[ShareOfShelfReport] ([Id])
ALTER TABLE [dbo].[ShareOfShelfImage] CHECK CONSTRAINT [FK_ShareOfShelfImage_ShareOfShelfReport]
