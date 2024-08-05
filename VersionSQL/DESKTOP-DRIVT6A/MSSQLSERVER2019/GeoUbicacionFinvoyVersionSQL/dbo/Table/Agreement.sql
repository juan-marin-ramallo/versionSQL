/****** Object:  Table [dbo].[Agreement]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Agreement](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[FileName] [varchar](100) NULL,
	[RealFileName] [varchar](100) NULL,
	[FileEncoded] [varbinary](max) NULL,
	[FileType] [varchar](50) NULL,
	[Description] [varchar](1000) NULL,
	[CreatedDate] [datetime] NULL,
	[Deleted] [bit] NULL,
	[DeletedDate] [datetime] NULL,
	[IdUser] [int] NULL,
	[AllPointOfInterest] [bit] NULL,
	[Identifier] [varchar](100) NULL,
	[MD5Checksum] [varchar](32) NULL,
 CONSTRAINT [PK_Agreement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Agreement]  WITH CHECK ADD  CONSTRAINT [FK_Agreement_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[Agreement] CHECK CONSTRAINT [FK_Agreement_User]
