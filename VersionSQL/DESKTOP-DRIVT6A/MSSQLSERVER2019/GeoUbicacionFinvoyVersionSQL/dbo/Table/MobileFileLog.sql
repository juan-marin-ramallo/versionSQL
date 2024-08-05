/****** Object:  Table [dbo].[MobileFileLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MobileFileLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
	[IdMobileFileLogType] [smallint] NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[Url] [varchar](5000) NOT NULL,
 CONSTRAINT [PK_MobileFileLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MobileFileLog]  WITH CHECK ADD  CONSTRAINT [FK_MobileFileLog_MobileFileLogType] FOREIGN KEY([IdMobileFileLogType])
REFERENCES [dbo].[MobileFileLogType] ([Id])
ALTER TABLE [dbo].[MobileFileLog] CHECK CONSTRAINT [FK_MobileFileLog_MobileFileLogType]
ALTER TABLE [dbo].[MobileFileLog]  WITH CHECK ADD  CONSTRAINT [FK_MobileFileLog_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[MobileFileLog] CHECK CONSTRAINT [FK_MobileFileLog_PersonOfInterest]
