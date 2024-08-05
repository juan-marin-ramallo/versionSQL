/****** Object:  Table [dbo].[ConfigurationGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ConfigurationGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Order] [int] NOT NULL,
	[IdParent] [int] NULL,
	[Visible] [bit] NOT NULL,
 CONSTRAINT [PK_ConfigurationGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ConfigurationGroup]  WITH CHECK ADD  CONSTRAINT [FK_ConfigurationGroup_ConfigurationGroup1] FOREIGN KEY([Id])
REFERENCES [dbo].[ConfigurationGroup] ([Id])
ALTER TABLE [dbo].[ConfigurationGroup] CHECK CONSTRAINT [FK_ConfigurationGroup_ConfigurationGroup1]
