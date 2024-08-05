/****** Object:  Table [dbo].[MarkErrorLog]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[MarkErrorLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[ReceivedDate] [datetime] NOT NULL,
	[IdPersonOfInterest] [int] NULL,
	[IdType] [smallint] NOT NULL,
	[IdPointOfInterest] [int] NULL,
	[Latitude] [decimal](25, 20) NULL,
	[Longitude] [decimal](25, 20) NULL,
	[ErrorMessage] [varchar](5000) NOT NULL,
	[OperationCode] [varchar](50) NOT NULL,
 CONSTRAINT [PK_MarkErrorLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
