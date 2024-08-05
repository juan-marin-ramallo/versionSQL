/****** Object:  Table [dbo].[MeetingGuest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MeetingGuest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MeetingId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Attended] [bit] NULL,
	[CanEdit] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_MeetingGuest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
