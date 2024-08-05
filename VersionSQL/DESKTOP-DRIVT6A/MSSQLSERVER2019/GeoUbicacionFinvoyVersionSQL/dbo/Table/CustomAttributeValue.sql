/****** Object:  Table [dbo].[CustomAttributeValue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [varchar](max) NULL,
	[IdCustomAttribute] [int] NOT NULL,
	[IdPointOfInterest] [int] NOT NULL,
	[IdCustomAttributeOption] [int] NULL,
 CONSTRAINT [PK_CustomAttributeValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [NCL_IX_CustomAttributeValue_IdPointOfInterest] ON [dbo].[CustomAttributeValue]
(
	[IdPointOfInterest] ASC
)
INCLUDE([IdCustomAttribute],[Value]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CustomAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttributeValue_CustomAttribute] FOREIGN KEY([IdCustomAttribute])
REFERENCES [dbo].[CustomAttribute] ([Id])
ALTER TABLE [dbo].[CustomAttributeValue] CHECK CONSTRAINT [FK_CustomAttributeValue_CustomAttribute]
ALTER TABLE [dbo].[CustomAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttributeValue_CustomAttributeOption] FOREIGN KEY([IdCustomAttributeOption])
REFERENCES [dbo].[CustomAttributeOption] ([Id])
ALTER TABLE [dbo].[CustomAttributeValue] CHECK CONSTRAINT [FK_CustomAttributeValue_CustomAttributeOption]
ALTER TABLE [dbo].[CustomAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_CustomAttributeValue_PointOfInterest] FOREIGN KEY([IdPointOfInterest])
REFERENCES [dbo].[PointOfInterest] ([Id])
ALTER TABLE [dbo].[CustomAttributeValue] CHECK CONSTRAINT [FK_CustomAttributeValue_PointOfInterest]
