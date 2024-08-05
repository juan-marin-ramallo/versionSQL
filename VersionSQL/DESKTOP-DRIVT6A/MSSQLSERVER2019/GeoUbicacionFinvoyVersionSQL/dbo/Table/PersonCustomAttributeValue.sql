/****** Object:  Table [dbo].[PersonCustomAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonCustomAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPersonCustomAttribute] [int] NOT NULL,
	[Value] [varchar](255) NULL,
	[IdPersonOfInterest] [int] NOT NULL,
 CONSTRAINT [PK__PersonCu__3214EC07A65DED2C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PersonCustomAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK__PersonCus__IdPer__255322C5] FOREIGN KEY([IdPersonCustomAttribute])
REFERENCES [dbo].[PersonCustomAttribute] ([Id])
ALTER TABLE [dbo].[PersonCustomAttributeValue] CHECK CONSTRAINT [FK__PersonCus__IdPer__255322C5]
ALTER TABLE [dbo].[PersonCustomAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK__PersonCus__IdPer__264746FE] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[PersonCustomAttributeValue] CHECK CONSTRAINT [FK__PersonCus__IdPer__264746FE]
