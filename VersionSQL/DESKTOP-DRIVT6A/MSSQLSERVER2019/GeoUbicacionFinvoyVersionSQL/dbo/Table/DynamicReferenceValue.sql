/****** Object:  Table [dbo].[DynamicReferenceValue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DynamicReferenceValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdDynamicReference] [int] NOT NULL,
	[IdDynamicProductPointOfInterest] [int] NOT NULL,
	[Value] [varchar](1000) NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_DynamicReferenceValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DynamicReferenceValue]  WITH CHECK ADD  CONSTRAINT [FK_DynamicReferenceValue_DynamicProductPointOfInterest] FOREIGN KEY([IdDynamicProductPointOfInterest])
REFERENCES [dbo].[DynamicProductPointOfInterest] ([Id])
ALTER TABLE [dbo].[DynamicReferenceValue] CHECK CONSTRAINT [FK_DynamicReferenceValue_DynamicProductPointOfInterest]
ALTER TABLE [dbo].[DynamicReferenceValue]  WITH CHECK ADD  CONSTRAINT [FK_DynamicReferenceValue_DynamicReference] FOREIGN KEY([IdDynamicReference])
REFERENCES [dbo].[DynamicReference] ([Id])
ALTER TABLE [dbo].[DynamicReferenceValue] CHECK CONSTRAINT [FK_DynamicReferenceValue_DynamicReference]
