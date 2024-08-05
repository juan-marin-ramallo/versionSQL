/****** Object:  Table [dbo].[InterestLink]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[InterestLink](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Value] [varchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[IdUser] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_InterestLink] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[InterestLink] ADD  CONSTRAINT [DF_InterestLink_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[InterestLink]  WITH CHECK ADD  CONSTRAINT [FK_InterestLink_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[InterestLink] CHECK CONSTRAINT [FK_InterestLink_User]
