/****** Object:  Table [dbo].[CustomAttributeGroupPersonType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomAttributeGroupPersonType](
	[IdCustomAttributeGroup] [int] NOT NULL,
	[PersonOfInterestType] [char](1) NOT NULL,
	[Order] [int] NOT NULL,
 CONSTRAINT [PK_CustomAttributeGroupPersonType] PRIMARY KEY CLUSTERED 
(
	[IdCustomAttributeGroup] ASC,
	[PersonOfInterestType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomAttributeGroupPersonType]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttributeGroupPersonType_CustomAttributeGroup] FOREIGN KEY([IdCustomAttributeGroup])
REFERENCES [dbo].[CustomAttributeGroup] ([Id])
ALTER TABLE [dbo].[CustomAttributeGroupPersonType] CHECK CONSTRAINT [FK_CustomAttributeGroupPersonType_CustomAttributeGroup]
ALTER TABLE [dbo].[CustomAttributeGroupPersonType]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttributeGroupPersonType_PersonOfInterestType] FOREIGN KEY([PersonOfInterestType])
REFERENCES [dbo].[PersonOfInterestType] ([Code])
ALTER TABLE [dbo].[CustomAttributeGroupPersonType] CHECK CONSTRAINT [FK_CustomAttributeGroupPersonType_PersonOfInterestType]
