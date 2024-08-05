/****** Object:  Table [dbo].[FormPlus]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[FormPlus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdForm] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
 CONSTRAINT [PK_FormPlus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[FormPlus]  WITH CHECK ADD  CONSTRAINT [FK_FormPlus_Form] FOREIGN KEY([IdForm])
REFERENCES [dbo].[Form] ([Id])
ALTER TABLE [dbo].[FormPlus] CHECK CONSTRAINT [FK_FormPlus_Form]
