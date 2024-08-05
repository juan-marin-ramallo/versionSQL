/****** Object:  Table [dbo].[WorkShift]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[WorkShift](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[IdType] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
 CONSTRAINT [PK_WorkShift] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[WorkShift]  WITH CHECK ADD  CONSTRAINT [FK_WorkShift_WorkShiftType] FOREIGN KEY([IdType])
REFERENCES [dbo].[WorkShiftType] ([Id])
ALTER TABLE [dbo].[WorkShift] CHECK CONSTRAINT [FK_WorkShift_WorkShiftType]
