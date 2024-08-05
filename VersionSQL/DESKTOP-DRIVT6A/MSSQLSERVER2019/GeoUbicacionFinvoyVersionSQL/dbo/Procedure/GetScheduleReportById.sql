/****** Object:  Procedure [dbo].[GetScheduleReportById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 23-04-2019
-- Description: Obtiene info de un reporte agendado por su id
-- =============================================
CREATE PROCEDURE [dbo].[GetScheduleReportById]
	@Id int
AS
BEGIN

	SELECT		C.[Id], C.[Name],
				T.[Id] AS IdType, T.[Name] AS TypeName,C.[FileFormat] AS IdFileFormat,
				FO.[Id] AS IdForm, FO.[Name] AS FormName,C. [DateFrom],C.[DateTo],C.[SubjectEmail],C.[BodyEmail],
				C.[RecurrenceCondition],C.[RecurrenceNumber],C.[SendingHour], 
				C.[IdPowerpointMarkup], C.[IdPowerPointStyle], C.[IdExcelFormat], C.[IdCustomReport], 
				C.[MonthDayNumber], C.[MonthDayPeriodFrom], C.[MonthDayPeriodTo], C.[MonthPeriodSentOption],
				C.[SendingPeriodFrom], [SendingPeriodTo], [DaySentOption], [WeekSentOption], [WeekDaysToCount],
				[MonthDayPeriodFromCalendar]

	FROM		[dbo].ScheduleReport C  WITH(NOLOCK)
	JOIN		[dbo].ScheduleReportTypeTranslated T  WITH(NOLOCK) ON T.[Id] = C.[IdTypeReport]
	LEFT JOIN [dbo].Form FO  WITH(NOLOCK) ON FO.[Id] = C.[IdForm]

	WHERE C.[Id] = @Id
	
END
