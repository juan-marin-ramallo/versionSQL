/****** Object:  Table [dbo].[MailExceptionLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MailExceptionLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[MailTo] [varchar](50) NULL,
	[MailSubject] [varchar](50) NULL,
	[ExceptionMessage] [varchar](max) NULL,
	[MailTemplate] [varchar](max) NULL,
 CONSTRAINT [PK_MailExceptionLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
