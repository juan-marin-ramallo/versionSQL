/****** Object:  Table [dbo].[CustomAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[IdValueType] [int] NOT NULL,
	[DefaultValue] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[IdUser] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[IsObligatory] [bit] NOT NULL,
	[IsVisible] [bit] NOT NULL,
	[CanDelete] [bit] NOT NULL,
	[CanEditObligatory] [bit] NOT NULL,
 CONSTRAINT [PK_CustomAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[CustomAttribute] ADD  CONSTRAINT [DF_CustomAttribute_ValueType]  DEFAULT ((0)) FOR [IdValueType]
ALTER TABLE [dbo].[CustomAttribute] ADD  CONSTRAINT [DF_CustomAttribute_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[CustomAttribute] ADD  CONSTRAINT [DF_CustomAttribute_IsObligatory]  DEFAULT ((0)) FOR [IsObligatory]
ALTER TABLE [dbo].[CustomAttribute] ADD  CONSTRAINT [DF_CustomAttribute_IsVisible]  DEFAULT ((1)) FOR [IsVisible]
ALTER TABLE [dbo].[CustomAttribute] ADD  CONSTRAINT [DF_CustomAttribute_CanDelete]  DEFAULT ((1)) FOR [CanDelete]
ALTER TABLE [dbo].[CustomAttribute] ADD  CONSTRAINT [DF_CustomAttribute_CanEditObligatory]  DEFAULT ((1)) FOR [CanEditObligatory]
ALTER TABLE [dbo].[CustomAttribute]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttribute_CustomAttributeValueType] FOREIGN KEY([IdValueType])
REFERENCES [dbo].[CustomAttributeValueType] ([Code])
ALTER TABLE [dbo].[CustomAttribute] CHECK CONSTRAINT [FK_CustomAttribute_CustomAttributeValueType]
ALTER TABLE [dbo].[CustomAttribute]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttribute_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[CustomAttribute] CHECK CONSTRAINT [FK_CustomAttribute_User]
