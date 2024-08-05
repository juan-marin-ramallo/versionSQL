/****** Object:  Table [dbo].[ConquestVerificationImage]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ConquestVerificationImage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdConquestVerification] [int] NOT NULL,
	[ImageName] [varchar](256) NOT NULL,
	[ImageUrl] [varchar](512) NULL,
 CONSTRAINT [PK_ConquestVerificationImage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_ConquestVerificationImage] UNIQUE NONCLUSTERED 
(
	[ImageName] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ConquestVerificationImage]  WITH CHECK ADD  CONSTRAINT [FK_ConquestVerificationImage_ConquestVerification] FOREIGN KEY([IdConquestVerification])
REFERENCES [dbo].[ConquestVerification] ([Id])
ALTER TABLE [dbo].[ConquestVerificationImage] CHECK CONSTRAINT [FK_ConquestVerificationImage_ConquestVerification]
