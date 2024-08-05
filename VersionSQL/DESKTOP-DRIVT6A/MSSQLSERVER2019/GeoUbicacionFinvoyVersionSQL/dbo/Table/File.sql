/****** Object:  Table [dbo].[File]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[File](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](100) NULL,
	[FileName] [varchar](500) NULL,
	[Url] [varchar](500) NULL,
	[Date] [datetime] NULL,
	[Deleted] [bit] NULL,
	[IdUser] [int] NULL,
	[Size] [int] NULL,
 CONSTRAINT [PK_Document] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[File]  WITH CHECK ADD  CONSTRAINT [FK_File_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[File] CHECK CONSTRAINT [FK_File_User]
