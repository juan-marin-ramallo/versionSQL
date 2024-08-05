/****** Object:  Table [dbo].[CustomAttributeGroupCustomAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomAttributeGroupCustomAttribute](
	[IdCustomAttributeGroup] [int] NOT NULL,
	[IdCustomAttribute] [int] NOT NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_CustomAttributeGroupCustomAttribute] PRIMARY KEY CLUSTERED 
(
	[IdCustomAttributeGroup] ASC,
	[IdCustomAttribute] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomAttributeGroupCustomAttribute]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttributeGroupCustomAttribute_CustomAttribute] FOREIGN KEY([IdCustomAttribute])
REFERENCES [dbo].[CustomAttribute] ([Id])
ALTER TABLE [dbo].[CustomAttributeGroupCustomAttribute] CHECK CONSTRAINT [FK_CustomAttributeGroupCustomAttribute_CustomAttribute]
ALTER TABLE [dbo].[CustomAttributeGroupCustomAttribute]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttributeGroupCustomAttribute_CustomAttributeGroup] FOREIGN KEY([IdCustomAttributeGroup])
REFERENCES [dbo].[CustomAttributeGroup] ([Id])
ALTER TABLE [dbo].[CustomAttributeGroupCustomAttribute] CHECK CONSTRAINT [FK_CustomAttributeGroupCustomAttribute_CustomAttributeGroup]
