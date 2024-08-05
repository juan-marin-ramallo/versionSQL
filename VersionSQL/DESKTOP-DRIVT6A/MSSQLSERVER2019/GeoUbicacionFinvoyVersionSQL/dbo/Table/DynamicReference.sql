/****** Object:  Table [dbo].[DynamicReference]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DynamicReference](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdDynamic] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_DynamicReference] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DynamicReference]  WITH CHECK ADD  CONSTRAINT [FK_DynamicReference_Dynamic] FOREIGN KEY([IdDynamic])
REFERENCES [dbo].[Dynamic] ([Id])
ALTER TABLE [dbo].[DynamicReference] CHECK CONSTRAINT [FK_DynamicReference_Dynamic]
