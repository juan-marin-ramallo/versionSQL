/****** Object:  Table [dbo].[Parameter]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[Parameter](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Deleted] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[IdUser] [int] NULL,
	[IdType] [int] NOT NULL,
	[Description] [varchar](500) NULL,
	[Value] [int] NULL,
	[Order] [int] NULL,
 CONSTRAINT [PK_Parameter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Parameter]  WITH CHECK ADD  CONSTRAINT [FK_Parameter_Type] FOREIGN KEY([IdType])
REFERENCES [dbo].[ParameterType] ([Id])
ALTER TABLE [dbo].[Parameter] CHECK CONSTRAINT [FK_Parameter_Type]
ALTER TABLE [dbo].[Parameter]  WITH CHECK ADD  CONSTRAINT [FK_Parameter_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[Parameter] CHECK CONSTRAINT [FK_Parameter_User]
