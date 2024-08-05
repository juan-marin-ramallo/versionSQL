/****** Object:  Table [dbo].[PowerpointMarkupFormReportElement]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[PowerpointMarkupFormReportElement](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPowerpointMarkupFormReport] [int] NOT NULL,
	[PageIndex] [int] NOT NULL,
	[IdPowerpointMarkupElement] [int] NOT NULL,
	[IdQuestion] [int] NOT NULL,
	[ShowTitle] [bit] NOT NULL,
 CONSTRAINT [PK_PowerpointMarkupFormReportElement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PowerpointMarkupFormReportElement]  WITH CHECK ADD  CONSTRAINT [FK_PowerpointMarkupFormReportElement_PowerpointMarkupElement] FOREIGN KEY([IdPowerpointMarkupElement])
REFERENCES [dbo].[PowerpointMarkupElement] ([Id])
ALTER TABLE [dbo].[PowerpointMarkupFormReportElement] CHECK CONSTRAINT [FK_PowerpointMarkupFormReportElement_PowerpointMarkupElement]
ALTER TABLE [dbo].[PowerpointMarkupFormReportElement]  WITH CHECK ADD  CONSTRAINT [FK_PowerpointMarkupFormReportElement_PowerpointMarkupFormReport] FOREIGN KEY([IdPowerpointMarkupFormReport])
REFERENCES [dbo].[PowerpointMarkupFormReport] ([Id])
ALTER TABLE [dbo].[PowerpointMarkupFormReportElement] CHECK CONSTRAINT [FK_PowerpointMarkupFormReportElement_PowerpointMarkupFormReport]
ALTER TABLE [dbo].[PowerpointMarkupFormReportElement]  WITH CHECK ADD  CONSTRAINT [FK_PowerpointMarkupFormReportElement_Question] FOREIGN KEY([IdQuestion])
REFERENCES [dbo].[Question] ([Id])
ALTER TABLE [dbo].[PowerpointMarkupFormReportElement] CHECK CONSTRAINT [FK_PowerpointMarkupFormReportElement_Question]
