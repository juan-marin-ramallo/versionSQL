/****** Object:  Procedure [dbo].[InsertAndCalculateScheduleReportSending]    Committed by VersionSQL https://www.versionsql.com ******/

-- Stored Procedure

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 12/04/2019
-- Description:	SP para guardar y generar envios
-- =============================================
CREATE PROCEDURE [dbo].[InsertAndCalculateScheduleReportSending]
(
	 @Id [sys].[int]
	,@StartDate [sys].DATETIME 
	,@EndDate [sys].DATETIME
	,@RecurrenceCondition [sys].CHAR 
	,@RecurrenceNumber [sys].[INT]
	,@DaysOfWeek [sys].VARCHAR(20) = NULL
	,@SendingHour [sys].[time](7)
	,@MonthDayNumber[sys].INT = NULL
	,@MonthDayPeriodFrom [sys].INT = NULL
	,@MonthDayPeriodTo [sys].INT = NULL
	,@MonthPeriodSentOption [sys].INT = NULL
	,@SendingPeriodFrom [sys].[time](7) = NULL
	,@SendingPeriodTo [sys].[time](7) = NULL
	,@DaySentOption [sys].INT = NULL
	,@WeekSentOption [sys].INT = NULL
	,@WeekDaysToCount [sys].INT = NULL
	,@MonthDayPeriodFromCalendar [sys].datetime = NULL
)
AS
BEGIN

	DECLARE @dayAux [sys].INT = NULL
	DECLARE @StartDateAux [sys].DATETIME = NULL

	----*****Busco ultimo dia ingresado para lOS MAILS y actualizo la fecha de comienzo

	IF EXISTS (SELECT 1 FROM [dbo].[ScheduleReportEmailsToSend] RD WHERE RD.[IdScheduleReport] = @Id)
	BEGIN
		SELECT TOP	1 @StartDateAux = RD.[EmailSendDateTime]
		FROM		[dbo].[ScheduleReportEmailsToSend] RD
		WHERE		RD.[IdScheduleReport] = @Id 
		ORDER BY	RD.[EmailSendDateTime] desc
	END

	IF @StartDateAux IS NULL OR @StartDateAux < @EndDate
	BEGIN

	--******************************************
		IF LEN(@DaysOfWeek) = 1
		BEGIN
			set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, 1, 1))  

			INSERT INTO [dbo].[ScheduleReportDayOfWeek]([IdScheduleReport], [DayOfWeek])
			VALUES		(@Id, @dayAux)

			EXEC CalculateAndSaveScheduleReports @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,
			@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber, 
			@Day = @dayAux, @IdScheduleReport = @Id, @SendingHour = @SendingHour, @MonthDayNumber = @MonthDayNumber ,
			@MonthDayPeriodFrom  = @MonthDayPeriodFrom, @MonthDayPeriodTo = @MonthDayPeriodTo,
			@MonthPeriodSentOption = @MonthPeriodSentOption, @SendingPeriodFrom = @SendingPeriodFrom, 
			@SendingPeriodTo = @SendingPeriodTo,@DaySentOption = @DaySentOption, @WeekSentOption = @WeekSentOption, 
			@WeekDaysToCount = @WeekDaysToCount, @MonthDayPeriodFromCalendar = @MonthDayPeriodFromCalendar

		END
		ELSE
		BEGIN
			DECLARE @pos INT = 0
			DECLARE @len INT = 0

			WHILE CHARINDEX(',', @DaysOfWeek, @pos)>0
			BEGIN
				set @len = CHARINDEX(',', @DaysOfWeek, @pos+1) - @pos
				set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, @len))

				INSERT INTO [dbo].[ScheduleReportDayOfWeek]([IdScheduleReport], [DayOfWeek])
				VALUES		(@Id, @dayAux)

				EXEC CalculateAndSaveScheduleReports @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,
				@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber, 
				@Day = @dayAux, @IdScheduleReport = @Id, @SendingHour = @SendingHour, @MonthDayNumber = @MonthDayNumber ,
				@MonthDayPeriodFrom  = @MonthDayPeriodFrom, @MonthDayPeriodTo = @MonthDayPeriodTo,
				@MonthPeriodSentOption = @MonthPeriodSentOption, @SendingPeriodFrom = @SendingPeriodFrom, 
				@SendingPeriodTo = @SendingPeriodTo,@DaySentOption = @DaySentOption, @WeekSentOption = @WeekSentOption, 
				@WeekDaysToCount = @WeekDaysToCount, @MonthDayPeriodFromCalendar = @MonthDayPeriodFromCalendar		

			set @pos = CHARINDEX(',', @DaysOfWeek, @pos+@len) +1
			END

			--INSERTO EL ULTIMO
			set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, 1))  

			INSERT INTO [dbo].[ScheduleReportDayOfWeek]([IdScheduleReport], [DayOfWeek])
			VALUES		(@Id, @dayAux)

			EXEC CalculateAndSaveScheduleReports @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,
			@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber, @Day = @dayAux, @IdScheduleReport = @Id, 
			@SendingHour = @SendingHour, @MonthDayNumber = @MonthDayNumber ,@MonthDayPeriodFrom  = @MonthDayPeriodFrom, 
			@MonthDayPeriodTo = @MonthDayPeriodTo,@MonthPeriodSentOption = @MonthPeriodSentOption, 
			@SendingPeriodFrom = @SendingPeriodFrom, @SendingPeriodTo = @SendingPeriodTo,@DaySentOption = @DaySentOption, 
			@WeekSentOption = @WeekSentOption, @WeekDaysToCount = @WeekDaysToCount, @MonthDayPeriodFromCalendar = @MonthDayPeriodFromCalendar
		END
	END
END
