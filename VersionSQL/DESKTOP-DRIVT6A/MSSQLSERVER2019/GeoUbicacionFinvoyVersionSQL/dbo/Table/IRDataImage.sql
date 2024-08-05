/****** Object:  Table [dbo].[IRDataImage]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[IRDataImage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdIRData] [int] NOT NULL,
	[ImageName] [varchar](256) NOT NULL,
 CONSTRAINT [PK_IRDataImage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[IRDataImage]  WITH CHECK ADD  CONSTRAINT [FK_IRDataImage_IdIRData_IRData_Id] FOREIGN KEY([IdIRData])
REFERENCES [dbo].[IRData] ([Id])
ALTER TABLE [dbo].[IRDataImage] CHECK CONSTRAINT [FK_IRDataImage_IdIRData_IRData_Id]
