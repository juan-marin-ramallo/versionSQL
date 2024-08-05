/****** Object:  Table [dbo].[ShareOfShelfEmptySpace]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ShareOfShelfEmptySpace](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdShareOfShelf] [int] NOT NULL,
	[X0] [int] NOT NULL,
	[Y0] [int] NOT NULL,
	[X1] [int] NOT NULL,
	[Y1] [int] NOT NULL,
 CONSTRAINT [PK_ShareOfShelfEmptySpace] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ShareOfShelfEmptySpace]  WITH CHECK ADD  CONSTRAINT [FK_ShareOfShelfEmptySpace_ShareOfShelfReport] FOREIGN KEY([IdShareOfShelf])
REFERENCES [dbo].[ShareOfShelfReport] ([Id])
ALTER TABLE [dbo].[ShareOfShelfEmptySpace] CHECK CONSTRAINT [FK_ShareOfShelfEmptySpace_ShareOfShelfReport]
