/****** Object:  Table [dbo].[ScheduleReportEmailsToSend]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE TABLE [dbo].[ScheduleReportEmailsToSend](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdScheduleReport] [int] NOT NULL,
	[DateFrom] [datetime] NOT NULL,
	[DateTo] [datetime] NOT NULL,
	[EmailSendDateTime] [datetime] NOT NULL,
	[Sent] [bit] NOT NULL,
	[SendingAttempts] [int] NOT NULL,
	[LastTryAttempt] [datetime] NULL,
 CONSTRAINT [PK_ScheduleReportEmailsToSend] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ScheduleReportEmailsToSend] ADD  CONSTRAINT [DF_ScheduleReportEmailsToSend_Sent]  DEFAULT ((0)) FOR [Sent]
ALTER TABLE [dbo].[ScheduleReportEmailsToSend] ADD  CONSTRAINT [DF_ScheduleReportEmailsToSend_SendingAttempts]  DEFAULT ((0)) FOR [SendingAttempts]
ALTER TABLE [dbo].[ScheduleReportEmailsToSend]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleReportEmailsToSend_ScheduleReport] FOREIGN KEY([IdScheduleReport])
REFERENCES [dbo].[ScheduleReport] ([Id])
ALTER TABLE [dbo].[ScheduleReportEmailsToSend] CHECK CONSTRAINT [FK_ScheduleReportEmailsToSend_ScheduleReport]
