/****** Object:  Table [dbo].[ProductBrand]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ProductBrand](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCompany] [int] NOT NULL,
	[Identifier] [varchar](50) NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](512) NULL,
	[ImageName] [varchar](256) NULL,
	[ImageUrl] [varchar](512) NULL,
	[IsSubBrand] [bit] NOT NULL,
	[IdFather] [int] NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_ProductBrand] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductBrand] ADD  CONSTRAINT [DF_ProductBrand_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[ProductBrand]  WITH CHECK ADD  CONSTRAINT [FK_ProductBrand_Company] FOREIGN KEY([IdCompany])
REFERENCES [dbo].[Company] ([Id])
ALTER TABLE [dbo].[ProductBrand] CHECK CONSTRAINT [FK_ProductBrand_Company]
ALTER TABLE [dbo].[ProductBrand]  WITH CHECK ADD  CONSTRAINT [FK_ProductBrand_ProductBrand] FOREIGN KEY([IdFather])
REFERENCES [dbo].[ProductBrand] ([Id])
ALTER TABLE [dbo].[ProductBrand] CHECK CONSTRAINT [FK_ProductBrand_ProductBrand]
