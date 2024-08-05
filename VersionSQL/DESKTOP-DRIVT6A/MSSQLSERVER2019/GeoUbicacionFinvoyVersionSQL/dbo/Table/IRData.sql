/****** Object:  Table [dbo].[IRData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[IRData](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Date] [datetime] NOT NULL,
	[IdCategory] [int] NOT NULL,
	[IdShareOfShelf] [int] NULL,
	[IdMissingProduct] [int] NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_IRData] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[IRData] ADD  CONSTRAINT [DF_IRData_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
ALTER TABLE [dbo].[IRData] ADD  CONSTRAINT [DF_IRData_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[IRData]  WITH CHECK ADD  CONSTRAINT [FK_IRData_IdCategory_ProductCategory_Id] FOREIGN KEY([IdCategory])
REFERENCES [dbo].[ProductCategory] ([Id])
ALTER TABLE [dbo].[IRData] CHECK CONSTRAINT [FK_IRData_IdCategory_ProductCategory_Id]
ALTER TABLE [dbo].[IRData]  WITH CHECK ADD  CONSTRAINT [FK_IRData_IdMissingProduct_ProductMissingPointOfInterest_Id] FOREIGN KEY([IdMissingProduct])
REFERENCES [dbo].[ProductMissingPointOfInterest] ([Id])
ALTER TABLE [dbo].[IRData] CHECK CONSTRAINT [FK_IRData_IdMissingProduct_ProductMissingPointOfInterest_Id]
ALTER TABLE [dbo].[IRData]  WITH CHECK ADD  CONSTRAINT [FK_IRData_IdPersonOfInterest_PersonOfInterest_Id] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[IRData] CHECK CONSTRAINT [FK_IRData_IdPersonOfInterest_PersonOfInterest_Id]
ALTER TABLE [dbo].[IRData]  WITH CHECK ADD  CONSTRAINT [FK_IRData_IdPointOfInterest_PointOfInterest_Id] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[IRData] CHECK CONSTRAINT [FK_IRData_IdPointOfInterest_PointOfInterest_Id]
ALTER TABLE [dbo].[IRData]  WITH CHECK ADD  CONSTRAINT [FK_IRData_IdShareOfShelf_ShareOfShelfReport_Id] FOREIGN KEY([IdShareOfShelf])
REFERENCES [dbo].[ShareOfShelfReport] ([Id])
ALTER TABLE [dbo].[IRData] CHECK CONSTRAINT [FK_IRData_IdShareOfShelf_ShareOfShelfReport_Id]
