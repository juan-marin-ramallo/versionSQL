/****** Object:  Procedure [dbo].[SaveScheduleReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 12/04/2019
-- Description:	SP para guardar un envio automatico de reporte
-- =============================================
CREATE PROCEDURE [dbo].[SaveScheduleReport]
(
	 @Id [sys].[int] = 0 OUTPUT
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
	,@MonthDayNumber [sys].INT = NULL
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

	begin try
	--******************************************
		INSERT INTO [dbo].[ScheduleReport]([DateFrom] ,[DateTo],[Name],[SubjectEmail],[BodyEmail],[IdTypeReport],
					[RecurrenceCondition],[RecurrenceNumber],[FileFormat],[SendingHour],[FileLink],[Deleted],[IdUser],
					[CreatedDate], [EditedDate], [IdForm], [IdPowerpointMarkup], [IdPowerPointStyle], [IdExcelFormat], [IdCustomReport], [MonthDayNumber], [MonthDayPeriodFrom], [MonthDayPeriodTo], [MonthPeriodSentOption],
					[SendingPeriodFrom], [SendingPeriodTo], [DaySentOption], [WeekSentOption], [WeekDaysToCount],[MonthDayPeriodFromCalendar])
		
		VALUES		(@StartDate, @EndDate, @Name, @Subject, @Body, @IdTypeReport, @RecurrenceCondition, @RecurrenceNumber,
					@IdFileFormat, @SendingHour, @FileLink, 0, @IdUser, @Now, @Now, 
					@IdForm, @IdPowerpointMarkup, @IdPowerPointStyle, @IdExcelFormat, @IdCustomReport, @MonthDayNumber, 
					@MonthDayPeriodFrom, @MonthDayPeriodTo, @MonthPeriodSentOption, @SendingPeriodFrom, 
					@SendingPeriodTo,@DaySentOption, @WeekSentOption, @WeekDaysToCount, @MonthDayPeriodFromCalendar)
   
	
		SET @Aux = SCOPE_IDENTITY()

		INSERT INTO [dbo].[ScheduleReportUser](IdScheduleReport, IdUser)
		(SELECT	@Aux, U.[Id]
		FROM	[dbo].[User] U
		WHERE	dbo.CheckValueInList(U.[Id], @IdUsers) = 1) 

		INSERT INTO [dbo].[ScheduleReportPersonOfInterest](IdScheduleReport, IdPersonOfInterest)
		(SELECT @Aux, P.[Id]
		FROM	[dbo].[PersonOfInterest] P
		WHERE	dbo.CheckValueInList(P.[Id], @IdPersonsOfInterest) = 1) 

		INSERT INTO [dbo].[ScheduleReportPointOfInterest](IdScheduleReport, IdPointOfInterest)
		(SELECT @Aux, P.[Id]
		FROM	[dbo].[PointOfInterest] P
		WHERE	dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1) 
		
		IF @Emails IS NOT NULL
		BEGIN
			INSERT INTO [dbo].[ScheduleReportUserEmail]([IdScheduleReport], [Email])
			(SELECT @Aux, Item FROM dbo.[SplitString](@Emails, ','));
		END

		COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION schedule_transaction; -- rollback to MySavePoint
			END
		END CATCH

		SELECT @Id = @Aux
	END
