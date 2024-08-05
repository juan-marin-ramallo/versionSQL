/****** Object:  Table [dbo].[Configuration]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Configuration](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](500) NOT NULL,
	[Value] [varchar](250) NOT NULL,
	[DescriptionPT] [varchar](100) NULL,
	[Visible] [bit] NOT NULL,
	[Order] [int] NOT NULL,
	[IdConfigurationGroup] [int] NOT NULL,
	[Type] [int] NOT NULL,
 CONSTRAINT [PK_Configuration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Configuration]  WITH CHECK ADD  CONSTRAINT [FK_Configuration_ConfigurationGroup] FOREIGN KEY([IdConfigurationGroup])
REFERENCES [dbo].[ConfigurationGroup] ([Id])
ALTER TABLE [dbo].[Configuration] CHECK CONSTRAINT [FK_Configuration_ConfigurationGroup]
