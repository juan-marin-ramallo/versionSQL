/****** Object:  Table [dbo].[DynamicPersonOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DynamicPersonOfInterest](
	[IdDynamic] [int] NOT NULL,
	[IdPersonOfInterest] [int] NOT NULL,
 CONSTRAINT [PK_DynamicPersonOfInterest] PRIMARY KEY CLUSTERED 
(
	[IdDynamic] ASC,
	[IdPersonOfInterest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DynamicPersonOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_DynamicPersonOfInterest_Dynamic] FOREIGN KEY([IdDynamic])
REFERENCES [dbo].[Dynamic] ([Id])
ALTER TABLE [dbo].[DynamicPersonOfInterest] CHECK CONSTRAINT [FK_DynamicPersonOfInterest_Dynamic]
ALTER TABLE [dbo].[DynamicPersonOfInterest]  WITH CHECK ADD  CONSTRAINT [FK_DynamicPersonOfInterest_PersonOfInterest] FOREIGN KEY([IdPersonOfInterest])
REFERENCES [dbo].[PersonOfInterest] ([Id])
ALTER TABLE [dbo].[DynamicPersonOfInterest] CHECK CONSTRAINT [FK_DynamicPersonOfInterest_PersonOfInterest]
