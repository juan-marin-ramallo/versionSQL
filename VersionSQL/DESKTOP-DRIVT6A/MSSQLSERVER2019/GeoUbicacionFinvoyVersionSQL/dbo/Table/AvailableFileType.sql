/****** Object:  Table [dbo].[AvailableFileType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AvailableFileType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FileType] [varchar](20) NOT NULL,
	[Description] [varchar](100) NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_AvailableFileType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AvailableFileType] ADD  CONSTRAINT [DF_AvailableFileType_Deleted]  DEFAULT ((0)) FOR [Deleted]
