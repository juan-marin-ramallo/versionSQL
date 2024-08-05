/****** Object:  Table [dbo].[ShareOfShelfItemCoordinates]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ShareOfShelfItemCoordinates](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdShareOfShelfItem] [int] NOT NULL,
	[X0] [int] NOT NULL,
	[Y0] [int] NOT NULL,
	[X1] [int] NOT NULL,
	[Y1] [int] NOT NULL,
 CONSTRAINT [PK_ShareOfShelfItemCoordinates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ShareOfShelfItemCoordinates]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfItemCoordinates_ShareOfShelfItem] FOREIGN KEY([IdShareOfShelfItem])
REFERENCES [dbo].[ShareOfShelfItem] ([Id])
ALTER TABLE [dbo].[ShareOfShelfItemCoordinates] CHECK CONSTRAINT [FK_ShareOfShelfItemCoordinates_ShareOfShelfItem]
