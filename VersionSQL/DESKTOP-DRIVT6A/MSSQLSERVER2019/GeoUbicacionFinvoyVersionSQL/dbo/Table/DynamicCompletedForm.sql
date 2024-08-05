/****** Object:  Table [dbo].[DynamicCompletedForm]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[DynamicCompletedForm](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdCompletedForm] [int] NULL,
	[IdDynamic] [int] NULL,
 CONSTRAINT [PK__DynamicC__3214EC075BD0317B] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DynamicCompletedForm]  WITH CHECK ADD  CONSTRAINT [FK__DynamicCo__IdCom__308FCB47] FOREIGN KEY([IdCompletedForm])
REFERENCES [dbo].[CompletedForm] ([Id])
ALTER TABLE [dbo].[DynamicCompletedForm] CHECK CONSTRAINT [FK__DynamicCo__IdCom__308FCB47]
ALTER TABLE [dbo].[DynamicCompletedForm]  WITH CHECK ADD  CONSTRAINT [FK__DynamicCo__IdDyn__3183EF80] FOREIGN KEY([IdDynamic])
REFERENCES [dbo].[Dynamic] ([Id])
ALTER TABLE [dbo].[DynamicCompletedForm] CHECK CONSTRAINT [FK__DynamicCo__IdDyn__3183EF80]
