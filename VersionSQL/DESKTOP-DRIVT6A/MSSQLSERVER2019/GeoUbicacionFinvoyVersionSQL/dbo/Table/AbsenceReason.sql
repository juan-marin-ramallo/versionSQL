/****** Object:  Table [dbo].[AbsenceReason]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[AbsenceReason](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[Deleted] [bit] NULL,
	[DeletedDate] [datetime] NULL,
	[EditedDate] [datetime] NULL,
 CONSTRAINT [PK_AbsenceReason] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
