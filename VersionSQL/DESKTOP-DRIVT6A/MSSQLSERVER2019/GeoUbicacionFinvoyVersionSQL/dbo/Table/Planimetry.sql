/****** Object:  Table [dbo].[Planimetry]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Planimetry](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](1000) NULL,
	[FileName] [varchar](100) NOT NULL,
	[FileEncoded] [varbinary](max) NULL,
	[RealFileName] [varchar](100) NULL,
	[FileType] [varchar](50) NULL,
	[IdBrand] [int] NULL,
	[IdProvider] [int] NULL,
	[IdCategory] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[IdUser] [int] NULL,
	[AllPointOfInterest] [bit] NULL,
	[Identifier] [varchar](100) NULL,
	[MD5Checksum] [varchar](32) NULL,
 CONSTRAINT [PK_Planimetry] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Planimetry]  WITH CHECK ADD  CONSTRAINT [FK_Planimetry_Brand] FOREIGN KEY([IdBrand])
REFERENCES [dbo].[Brand] ([Id])
ALTER TABLE [dbo].[Planimetry] CHECK CONSTRAINT [FK_Planimetry_Brand]
ALTER TABLE [dbo].[Planimetry]  WITH CHECK ADD  CONSTRAINT [FK_Planimetry_Category] FOREIGN KEY([IdCategory])
REFERENCES [dbo].[Category] ([Id])
ALTER TABLE [dbo].[Planimetry] CHECK CONSTRAINT [FK_Planimetry_Category]
ALTER TABLE [dbo].[Planimetry]  WITH CHECK ADD  CONSTRAINT [FK_Planimetry_Provider] FOREIGN KEY([IdProvider])
REFERENCES [dbo].[Provider] ([Id])
ALTER TABLE [dbo].[Planimetry] CHECK CONSTRAINT [FK_Planimetry_Provider]
ALTER TABLE [dbo].[Planimetry]  WITH CHECK ADD  CONSTRAINT [FK_Planimetry_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[Planimetry] CHECK CONSTRAINT [FK_Planimetry_User]
