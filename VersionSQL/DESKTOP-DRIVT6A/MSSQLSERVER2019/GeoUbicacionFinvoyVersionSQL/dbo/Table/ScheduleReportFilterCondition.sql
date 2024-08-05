/****** Object:  Table [dbo].[ScheduleReportFilterCondition]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleReportFilterCondition](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdScheduleReport] [int] NOT NULL,
	[IdQuestion] [int] NULL,
	[IdProduct] [int] NULL,
	[IdProductReportAttribute] [int] NULL,
	[ConditionType] [varchar](3) NOT NULL,
	[ConditionValue] [varchar](5000) NULL,
 CONSTRAINT [PK_ScheduleReportFilterCondition] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleReportFilterCondition]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportFilterCondition_Product] FOREIGN KEY([IdProduct])
REFERENCES [dbo].[Product] ([Id])
ALTER TABLE [dbo].[ScheduleReportFilterCondition] CHECK CONSTRAINT [FK_ScheduleReportFilterCondition_Product]
ALTER TABLE [dbo].[ScheduleReportFilterCondition]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportFilterCondition_ProductReportAttribute] FOREIGN KEY([IdProductReportAttribute])
REFERENCES [dbo].[ProductReportAttribute] ([Id])
ALTER TABLE [dbo].[ScheduleReportFilterCondition] CHECK CONSTRAINT [FK_ScheduleReportFilterCondition_ProductReportAttribute]
ALTER TABLE [dbo].[ScheduleReportFilterCondition]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportFilterCondition_Question] FOREIGN KEY([IdQuestion])
REFERENCES [dbo].[Question] ([Id])
ALTER TABLE [dbo].[ScheduleReportFilterCondition] CHECK CONSTRAINT [FK_ScheduleReportFilterCondition_Question]
ALTER TABLE [dbo].[ScheduleReportFilterCondition]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportFilterCondition_ScheduleReport] FOREIGN KEY([IdScheduleReport])
REFERENCES [dbo].[ScheduleReport] ([Id])
ALTER TABLE [dbo].[ScheduleReportFilterCondition] CHECK CONSTRAINT [FK_ScheduleReportFilterCondition_ScheduleReport]
