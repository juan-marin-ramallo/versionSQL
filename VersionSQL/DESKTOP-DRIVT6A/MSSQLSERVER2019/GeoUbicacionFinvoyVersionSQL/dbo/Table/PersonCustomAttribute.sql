/****** Object:  Table [dbo].[PersonCustomAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PersonCustomAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[IdType] [int] NOT NULL,
	[IdUser] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK__PersonCu__3214EC07AB0F4F5D] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PersonCustomAttribute]  WITH CHECK ADD  CONSTRAINT [FK__PersonCus__IdTyp__1CBDDCC4] FOREIGN KEY([IdType])
REFERENCES [dbo].[CustomAttributeValueType] ([Code])
ALTER TABLE [dbo].[PersonCustomAttribute] CHECK CONSTRAINT [FK__PersonCus__IdTyp__1CBDDCC4]
