/****** Object:  Table [dbo].[DynamicReferenceCompletedForm]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DynamicReferenceCompletedForm](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdDynamicCompletedForm] [int] NULL,
	[IdDynamicReference] [int] NULL,
	[IdDynamicReferenceValue] [int] NULL,
 CONSTRAINT [PK__DynamicR__3214EC07672BD912] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DynamicReferenceCompletedForm]  WITH CHECK ADD  CONSTRAINT [FK__DynamicRe__IdDyn__34605C2B] FOREIGN KEY([IdDynamicCompletedForm])
REFERENCES [dbo].[DynamicCompletedForm] ([Id])
ALTER TABLE [dbo].[DynamicReferenceCompletedForm] CHECK CONSTRAINT [FK__DynamicRe__IdDyn__34605C2B]
ALTER TABLE [dbo].[DynamicReferenceCompletedForm]  WITH CHECK ADD  CONSTRAINT [FK__DynamicRe__IdDyn__35548064] FOREIGN KEY([IdDynamicReference])
REFERENCES [dbo].[DynamicReference] ([Id])
ALTER TABLE [dbo].[DynamicReferenceCompletedForm] CHECK CONSTRAINT [FK__DynamicRe__IdDyn__35548064]
ALTER TABLE [dbo].[DynamicReferenceCompletedForm]  WITH CHECK ADD  CONSTRAINT [FK__DynamicRe__IdDyn__3648A49D] FOREIGN KEY([IdDynamicReferenceValue])
REFERENCES [dbo].[DynamicReferenceValue] ([Id])
ALTER TABLE [dbo].[DynamicReferenceCompletedForm] CHECK CONSTRAINT [FK__DynamicRe__IdDyn__3648A49D]
