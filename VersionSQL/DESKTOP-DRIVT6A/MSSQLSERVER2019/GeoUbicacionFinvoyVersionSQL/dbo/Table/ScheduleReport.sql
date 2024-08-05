/****** Object:  Table [dbo].[ScheduleReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DateFrom] [datetime] NOT NULL,
	[DateTo] [datetime] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[SubjectEmail] [varchar](100) NULL,
	[BodyEmail] [varchar](500) NULL,
	[IdTypeReport] [int] NOT NULL,
	[RecurrenceCondition] [char](1) NOT NULL,
	[RecurrenceNumber] [int] NOT NULL,
	[FileFormat] [int] NULL,
	[SendingHour] [time](7) NOT NULL,
	[FileLink] [varchar](5000) NULL,
	[Deleted] [bit] NOT NULL,
	[IdUser] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[EditedDate] [datetime] NULL,
	[IdForm] [int] NULL,
	[IdPowerpointMarkup] [int] NULL,
	[IdExcelFormat] [int] NULL,
	[IdCustomReport] [int] NULL,
	[MonthDayNumber] [int] NULL,
	[MonthDayPeriodFrom] [int] NULL,
	[MonthDayPeriodTo] [int] NULL,
	[MonthPeriodSentOption] [int] NULL,
	[SendingPeriodFrom] [time](7) NULL,
	[SendingPeriodTo] [time](7) NULL,
	[DaySentOption] [int] NULL,
	[WeekSentOption] [int] NULL,
	[WeekDaysToCount] [int] NULL,
	[IdPowerPointStyle] [int] NULL,
	[MonthDayPeriodFromCalendar] [datetime] NULL,
 CONSTRAINT [PK_ScheduleReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleReport] ADD  CONSTRAINT [DF_ScheduleReport_Deleted]  DEFAULT ((0)) FOR [Deleted]
ALTER TABLE [dbo].[ScheduleReport]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReport_AvailableFileType] FOREIGN KEY([FileFormat])
REFERENCES [dbo].[AvailableFileType] ([Id])
ALTER TABLE [dbo].[ScheduleReport] CHECK CONSTRAINT [FK_ScheduleReport_AvailableFileType]
ALTER TABLE [dbo].[ScheduleReport]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReport_CustomReport] FOREIGN KEY([IdCustomReport])
REFERENCES [dbo].[CustomReport] ([Id])
ALTER TABLE [dbo].[ScheduleReport] CHECK CONSTRAINT [FK_ScheduleReport_CustomReport]
ALTER TABLE [dbo].[ScheduleReport]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReport_Form] FOREIGN KEY([IdForm])
REFERENCES [dbo].[Form] ([Id])
ALTER TABLE [dbo].[ScheduleReport] CHECK CONSTRAINT [FK_ScheduleReport_Form]
ALTER TABLE [dbo].[ScheduleReport]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReport_FormReportFormatElement] FOREIGN KEY([IdExcelFormat])
REFERENCES [dbo].[FormReportFormatElement] ([Id])
ALTER TABLE [dbo].[ScheduleReport] CHECK CONSTRAINT [FK_ScheduleReport_FormReportFormatElement]
ALTER TABLE [dbo].[ScheduleReport]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReport_PowerpointMarkup] FOREIGN KEY([IdPowerpointMarkup])
REFERENCES [dbo].[PowerpointMarkupFormReport] ([Id])
ALTER TABLE [dbo].[ScheduleReport] CHECK CONSTRAINT [FK_ScheduleReport_PowerpointMarkup]
ALTER TABLE [dbo].[ScheduleReport]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReport_ScheduleReportType] FOREIGN KEY([IdTypeReport])
REFERENCES [dbo].[ScheduleReportType] ([Id])
ALTER TABLE [dbo].[ScheduleReport] CHECK CONSTRAINT [FK_ScheduleReport_ScheduleReportType]
ALTER TABLE [dbo].[ScheduleReport]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReport_User] FOREIGN KEY([IdUser])
REFERENCES [dbo].[User] ([Id])
ALTER TABLE [dbo].[ScheduleReport] CHECK CONSTRAINT [FK_ScheduleReport_User]
