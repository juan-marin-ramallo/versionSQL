/****** Object:  Table [dbo].[SynchronizationLogError]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[SynchronizationLogError](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdSynchronizationLog] [int] NOT NULL,
	[Class] [varchar](32) NOT NULL,
	[Data] [varchar](2048) NOT NULL,
	[ErrorType] [int] NOT NULL,
 CONSTRAINT [PK_SynchronizationLogError] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SynchronizationLogError]  WITH CHECK ADD  CONSTRAINT [FK_SynchronizationLogError_SynchronizationLog] FOREIGN KEY([IdSynchronizationLog])
REFERENCES [dbo].[SynchronizationLog] ([Id])
ALTER TABLE [dbo].[SynchronizationLogError] CHECK CONSTRAINT [FK_SynchronizationLogError_SynchronizationLog]
