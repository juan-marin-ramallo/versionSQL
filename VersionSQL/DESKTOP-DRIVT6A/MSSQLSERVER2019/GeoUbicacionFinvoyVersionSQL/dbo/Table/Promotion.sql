/****** Object:  Table [dbo].[Promotion]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Promotion](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[Description] [varchar](1000) NULL,
	[FileName] [varchar](100) NULL,
	[RealFileName] [varchar](100) NULL,
	[FileEncoded] [varbinary](max) NULL,
	[CreatedDate] [datetime] NULL,
	[Deleted] [bit] NULL,
	[DeletedDate] [datetime] NULL,
	[IdUser] [int] NULL,
	[AllPointOfInterest] [bit] NULL,
	[Identifier] [varchar](100) NULL,
	[MD5Checksum] [varchar](32) NULL,
 CONSTRAINT [PK_Promotion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Promotion]  WITH CHECK ADD  CONSTRAINT [FK_Promotion_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[Promotion] CHECK CONSTRAINT [FK_Promotion_User]
