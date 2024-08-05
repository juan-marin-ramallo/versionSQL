/****** Object:  Table [dbo].[CustomReportDynamic]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[CustomReportDynamic](
	[IdCustomReport] [int] NOT NULL,
	[IdDynamic] [int] NOT NULL,
 CONSTRAINT [PK__CustomRe__5DDBA256A80B0D1A] PRIMARY KEY CLUSTERED 
(
	[IdCustomReport] ASC,
	[IdDynamic] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomReportDynamic]  WITH CHECK ADD  CONSTRAINT [FK__CustomRep__IdCus__3EDDEA9E] FOREIGN KEY([IdCustomReport])
REFERENCES [dbo].[CustomReport] ([Id])
ALTER TABLE [dbo].[CustomReportDynamic] CHECK CONSTRAINT [FK__CustomRep__IdCus__3EDDEA9E]
ALTER TABLE [dbo].[CustomReportDynamic]  WITH CHECK ADD  CONSTRAINT [FK__CustomRep__IdDyn__3FD20ED7] FOREIGN KEY([IdDynamic])
REFERENCES [dbo].[Dynamic] ([Id])
ALTER TABLE [dbo].[CustomReportDynamic] CHECK CONSTRAINT [FK__CustomRep__IdDyn__3FD20ED7]
