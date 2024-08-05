/****** Object:  Procedure [dbo].[UpdateScheduleReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 12/04/2019
-- Description:	SP para actualizar un envio automatico de reporte
-- =============================================
CREATE PROCEDURE [dbo].[UpdateScheduleReport]
(
	 @IdScheduleReport [sys].[int]
	,@StartDate [sys].DATETIME 
	,@EndDate [sys].DATETIME
	,@Name [sys].VARCHAR(100)
    ,@Subject [sys].VARCHAR(100) = NULL
	,@Body [sys].VARCHAR(500) = NULL
	,@IdTypeReport [sys].[int]
	,@RecurrenceCondition [sys].CHAR 
	,@RecurrenceNumber [sys].[INT]
	,@IdFileFormat [sys].[int] = NULL
	,@SendingHour [sys].[time](7)
	,@Emails [sys].VARCHAR(1500) = NULL
	,@FileLink [sys].VARCHAR(5000)
	,@IdUser [sys].[int] = NULL
	,@IdUsers [sys].VARCHAR(max) = NULL
	,@IdForm [sys].INT = NULL
	,@IdPowerpointMarkup [sys].INT = NULL
	,@IdPowerPointStyle [sys].[int] = NULL
	,@DaysOfWeek [sys].VARCHAR(20) = NULL
	,@IdPersonsOfInterest [sys].VARCHAR(max) = NULL
	,@IdPointsOfInterest [sys].VARCHAR(max) = NULL
	,@IdExcelFormat [sys].INT = NULL
	,@IdCustomReport [sys].INT = NULL
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
	BEGIN TRANSACTION
	SAVE TRANSACTION schedule_transaction;
	DECLARE @Aux [sys].[int]
	DECLARE @dayAux [sys].INT = NULL
	DECLARE @emailAux [sys].varchar(100) = NULL
    
    DECLARE @Now [sys].[datetime]
    SET @Now = GETUTCDATE()

	BEGIN TRY
	--******************************************
		UPDATE	[dbo].[ScheduleReport]
		SET		[DateFrom] = @StartDate,
				[DateTo]= @EndDate, [Name] = @Name, [SubjectEmail] = @Subject, [BodyEmail] = @Body, [IdTypeReport] = @IdTypeReport, [RecurrenceCondition] = @RecurrenceCondition, 
				[RecurrenceNumber] = @RecurrenceNumber,
				[FileFormat] = @IdFileFormat, [SendingHour] = @SendingHour, [FileLink] = @FileLink, [EditedDate] = @Now, 
				[IdForm] = @IdForm, [IdPowerpointMarkup] = @IdPowerpointMarkup, [IdPowerPointStyle] = @IdPowerPointStyle, [IdExcelFormat] = @IdExcelFormat,
				[IdCustomReport] = @IdCustomReport, [MonthDayNumber] = @MonthDayNumber, [MonthDayPeriodFrom] = @MonthDayPeriodFrom, [MonthDayPeriodTo] = @MonthDayPeriodTo, 
				[MonthPeriodSentOption] = @MonthPeriodSentOption, [SendingPeriodFrom] = @SendingPeriodFrom, 
				[SendingPeriodTo] = @SendingPeriodTo, [DaySentOption] = @DaySentOption, 
				[WeekSentOption] = @WeekSentOption, [WeekDaysToCount] = @WeekDaysToCount,
				[MonthDayPeriodFromCalendar] = @MonthDayPeriodFromCalendar 
		WHERE	[Id] = @IdScheduleReport
   
	
		SET @Aux = @IdScheduleReport

		DELETE FROM [ScheduleReportUser]
		WHERE [IdScheduleReport] = @Aux

		INSERT INTO [dbo].[ScheduleReportUser](IdScheduleReport, IdUser)
		(SELECT	@Aux, U.[Id]
		FROM	[dbo].[User] U
		WHERE	dbo.CheckValueInList(U.[Id], @IdUsers) = 1) 

		DELETE FROM [ScheduleReportPersonOfInterest]
		WHERE [IdScheduleReport] = @Aux

		INSERT INTO [dbo].[ScheduleReportPersonOfInterest](IdScheduleReport, IdPersonOfInterest)
		(SELECT @Aux, P.[Id]
		FROM	[dbo].[PersonOfInterest] P
		WHERE	dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1) 

		DELETE FROM [ScheduleReportPointOfInterest]
		WHERE [IdScheduleReport] = @Aux

		INSERT INTO [dbo].[ScheduleReportPointOfInterest](IdScheduleReport, IdPointOfInterest)
		(SELECT @Aux, P.[Id]
		FROM	[dbo].[PointOfInterest] P
		WHERE	dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1) 
		
		DELETE FROM [ScheduleReportUserEmail]
		WHERE [IdScheduleReport] = @Aux

		IF @Emails IS NOT NULL
		BEGIN
			INSERT INTO [dbo].[ScheduleReportUserEmail]([IdScheduleReport], [Email])
			(SELECT @Aux, Item FROM dbo.[SplitString](@Emails, ','));
		END

		DELETE FROM [ScheduleReportDayOfWeek]
		WHERE [IdScheduleReport] = @Aux

		DELETE FROM [ScheduleReportEmailsToSend]
		WHERE [IdScheduleReport] = @Aux AND Tzdb.IsGreaterOrSameSystemDate([EmailSendDateTime], @Now) = 1 AND [Sent] = 0
              --AND DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc([EmailSendDateTime])), 0) > DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(@Now)), 0)

	
		COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION schedule_transaction; -- rollback to MySavePoint
		END
		END CATCH
	END
