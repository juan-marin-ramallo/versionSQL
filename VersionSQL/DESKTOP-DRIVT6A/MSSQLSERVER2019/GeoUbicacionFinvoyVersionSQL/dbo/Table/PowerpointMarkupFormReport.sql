/****** Object:  Table [dbo].[PowerpointMarkupFormReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PowerpointMarkupFormReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdForm] [int] NOT NULL,
	[Name] [varchar](250) NOT NULL,
	[ShowTitles] [bit] NOT NULL,
 CONSTRAINT [PK_PowerpointMarkupFormReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PowerpointMarkupFormReport] ADD  CONSTRAINT [DF_PowerpointMarkupFormReport_ShowTitles]  DEFAULT ((0)) FOR [ShowTitles]
ALTER TABLE [dbo].[PowerpointMarkupFormReport]  WITH CHECK ADD  CONSTRAINT [FK_PowerpointMarkupFormReport_Form] FOREIGN KEY([IdForm])
REFERENCES [dbo].[Form] ([Id])
ALTER TABLE [dbo].[PowerpointMarkupFormReport] CHECK CONSTRAINT [FK_PowerpointMarkupFormReport_Form]
