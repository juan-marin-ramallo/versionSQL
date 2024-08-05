/****** Object:  Table [dbo].[Company]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Company](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](512) NULL,
	[ImageName] [varchar](256) NULL,
	[ImageUrl] [varchar](512) NULL,
	[IsMain] [bit] NOT NULL,
	[Identifier] [varchar](50) NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_Deleted]  DEFAULT ((0)) FOR [Deleted]
