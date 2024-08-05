/****** Object:  Table [dbo].[ChatUser]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ChatUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdUser] [int] NULL,
	[IdPersonOfInterest] [int] NULL,
	[UserId] [varchar](100) NULL,
	[DisplayName] [varchar](500) NULL,
	[ImageLink] [varchar](255) NULL,
	[Deleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
 CONSTRAINT [PK_ChatUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
