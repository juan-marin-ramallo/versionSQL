/****** Object:  Procedure [dbo].[CalculateAndSaveScheduleReports]    Committed by VersionSQL https://www.versionsql.com ******/

-- Stored Procedure

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 16/04/2019
-- Description:	SP para calcular y guardar los envios de los reportes automaticos
-- =============================================
CREATE PROCEDURE [dbo].[CalculateAndSaveScheduleReports]
(
     @TheoricalStartDate [sys].DATETIME,
	 @TheoricalEndDate [sys].DATETIME ,
	 @RCondition [sys].CHAR,
	 @RNumber [sys].int,
	 @Day [sys].INT = NULL,
	 @IdScheduleReport [sys].INT ,
	 @SendingHour [sys].[time](7),
	 @MonthDayNumber[sys].INT = NULL
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
	IF @TheoricalStartDate IS NOT NULL
	BEGIN
		SET @TheoricalStartDate = Tzdb.FromUtc(@TheoricalStartDate)
	END

	DECLARE @TheoricalEndDateTruncated [sys].[date]
	IF @TheoricalEndDate IS NOT NULL
	BEGIN
		SET @TheoricalEndDateTruncated = Tzdb.FromUtc(@TheoricalEndDate)
	END

	DECLARE @Today [sys].[date]
	SET @Today = Tzdb.FromUtc(GETUTCDATE())

	DECLARE @RealStartDate [sys].DATETIME
	DECLARE @DateAuxiliar [sys].DATETIME
	DECLARE @DayOfWeekMonth [sys].INT
	DECLARE @DateAuxiliarFrom [sys].DATETIME
	DECLARE @DateAuxiliarTo [sys].DATETIME

	--Calculo comienzo real verificando la fecha
	;WITH myWeek AS
	(
		SELECT @TheoricalStartDate AS myDay, DATEPART(WEEKDAY, @TheoricalStartDate) as MyDayofWeek
		UNION ALL
		SELECT DATEADD(DAY, 1, myDay) AS myDay,  DATEPART(WEEKDAY, DATEADD(DAY, 1, myDay)) as MyDayofWeek 
		FROM myWeek WHERE  DATEDIFF(DAY, @TheoricalStartDate, myday) < 6
	)

	SELECT @RealStartDate = myDay FROM myWeek WHERE MyDayofWeek = @Day

	SET @DateAuxiliar = DATEADD(day, DATEDIFF(day, 0, @RealStartDate), CAST(@SendingHour AS DATETIME)) --RealSatrtDate a la hora que se envia el formulario


	IF @RCondition = 'D'
	BEGIN
		WHILE  CAST(@DateAuxiliar AS [sys].[date]) <=  @TheoricalEndDateTruncated
		BEGIN


			IF @DaySentOption = 1 --El periodo a enviar es el mismo dia.
			BEGIN

				SET @DateAuxiliarFrom = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliar), CAST(@SendingPeriodFrom AS DATETIME))
				SET @DateAuxiliarTo = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliar), CAST(@SendingPeriodTo AS DATETIME))

			END
			ELSE
			BEGIN
				--Periodo a enviar es del dia anterior
				SET @DateAuxiliarFrom = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliar), CAST(@SendingPeriodFrom AS DATETIME))
				SET @DateAuxiliarFrom = DATEADD(day, -1, @DateAuxiliarFrom)
				SET @DateAuxiliarTo = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliar), CAST(@SendingPeriodTo AS DATETIME))
				SET @DateAuxiliarTo = DATEADD(day, -1, @DateAuxiliarTo)
			END

			IF CAST(@DateAuxiliar AS DATE) >= @Today
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM [ScheduleReportEmailsToSend] WHERE IdScheduleReport = @IdScheduleReport and [EmailSendDateTime] = Tzdb.ToUtc(@DateAuxiliar))
				BEGIN
					INSERT INTO [dbo].[ScheduleReportEmailsToSend]([IdScheduleReport], [DateFrom], [DateTo], [EmailSendDateTime])
					VALUES		(@IdScheduleReport, Tzdb.ToUtc(@DateAuxiliarFrom), Tzdb.ToUtc(@DateAuxiliarTo), Tzdb.ToUtc(@DateAuxiliar))
				END
			END
			SET @DateAuxiliar = DATEADD(WEEK, @RNumber, @DateAuxiliar)
        END 
	END

	IF @RCondition = 'W'
	BEGIN
		WHILE CAST(@DateAuxiliar AS [sys].[date]) <= @TheoricalEndDateTruncated
		BEGIN

			IF @WeekSentOption = 1 --Tengo que incluir dia de envio y dia de inicio contando para atras
			BEGIN
				SET @DateAuxiliarFrom = DATEADD(DAY, -@WeekDaysToCount, @DateAuxiliar)
				SET @DateAuxiliarFrom = CAST(@DateAuxiliarFrom AS DATE)
				SET @DateAuxiliarTo = @DateAuxiliar
			END
			ELSE IF @WeekSentOption = 2 --Se tiene en cuenta la información del día del envio y no la del día inicio.
			BEGIN
				SET @DateAuxiliarFrom = DATEADD(DAY, 1, DATEADD(DAY, -@WeekDaysToCount, @DateAuxiliar))
				SET @DateAuxiliarFrom = CAST(@DateAuxiliarFrom AS DATE)
				SET @DateAuxiliarTo = @DateAuxiliar
			END
			ELSE IF @WeekSentOption = 3 --No se tiene en cuenta la información del día del envio y si la del inicio
			BEGIN
				SET @DateAuxiliarFrom = DATEADD(DAY, -@WeekDaysToCount, @DateAuxiliar)
				SET @DateAuxiliarFrom = CAST(@DateAuxiliarFrom AS DATE)
				SET @DateAuxiliarTo = DATEADD(DAY, -1, @DateAuxiliar)
				SET @DateAuxiliarTo = CAST(@DateAuxiliarTo AS DATE)
				SET @DateAuxiliarTo = DATEADD(HOUR, 23, @DateAuxiliarTo) 
				SET @DateAuxiliarTo = DATEADD(MINUTE, 59, @DateAuxiliarTo) 
			END

			IF CAST(@DateAuxiliar AS DATE) >= @Today
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM [ScheduleReportEmailsToSend] WHERE IdScheduleReport = @IdScheduleReport and [EmailSendDateTime] = Tzdb.ToUtc(@DateAuxiliar))
				BEGIN
					INSERT INTO [dbo].[ScheduleReportEmailsToSend]([IdScheduleReport], [DateFrom], [DateTo], [EmailSendDateTime])
					VALUES		(@IdScheduleReport, Tzdb.ToUtc(@DateAuxiliarFrom), Tzdb.ToUtc(@DateAuxiliarTo), Tzdb.ToUtc(@DateAuxiliar))
				END
			END
			SET @DateAuxiliar = DATEADD(WEEK, @RNumber, @DateAuxiliar)
        END 
	END

	IF @RCondition = 'M'
	BEGIN

		DECLARE @StartDateMonth [sys].INT
		DECLARE @StartDateYear [sys].INT
		DECLARE @Auxiliar [sys].datetime
		DECLARE @AuxiliarForOption2 [sys].datetime

		SET @StartDateMonth = DATEPART(MONTH, @TheoricalStartDate)
		SET @StartDateYear = DATEPART(YEAR, @TheoricalStartDate)
		SET @Auxiliar = DATEFROMPARTS(@StartDateYear, @StartDateMonth, 1) 

		BEGIN TRY  
			SET @RealStartDate = DATEFROMPARTS(@StartDateYear, @StartDateMonth, @MonthDayNumber) 
		END TRY  
		BEGIN CATCH  
			 SET @RealStartDate = DATEFROMPARTS(@StartDateYear, @StartDateMonth, DATEPART(DAY ,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@Auxiliar)+1,0)))) --Busco ultimo dia de ese mes porque si fallò asumo que es por eso
		END CATCH 


		IF @RealStartDate < @TheoricalStartDate
		BEGIN
			--Empieza el mes siguiente
			SET @Auxiliar = DATEFROMPARTS(@StartDateYear, @StartDateMonth + 1, 1) 
			BEGIN TRY  
				SET @RealStartDate = DATEFROMPARTS(@StartDateYear, @StartDateMonth + 1, @MonthDayNumber) 
			END TRY  
			BEGIN CATCH  
				 SET @RealStartDate = DATEFROMPARTS(@StartDateYear, @StartDateMonth + 1, DATEPART(DAY, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@Auxiliar)+1,0)))) --Busco ultimo dia de ese mes porque si fallò asumo que es por eso
			END CATCH 
		END

		IF @MonthPeriodSentOption = 1 --El periodo a enviar es el mismo mes.
		BEGIN

			SET @DateAuxiliar = DATEADD(day, DATEDIFF(day, 0, @RealStartDate), CAST(@SendingHour AS DATETIME)) --RealSatrtDate a la hora que se envia el formulario

			WHILE CAST(@DateAuxiliar AS [sys].[date]) <= @TheoricalEndDateTruncated
			BEGIN		

				--Tengo que definir los DateFrom y los DateTo para el reporte.	

				SET @DateAuxiliarFrom = DATEFROMPARTS(DATEPART(YEAR, @DateAuxiliar), DATEPART(MONTH, @DateAuxiliar), @MonthDayPeriodFrom)
				BEGIN TRY  
					SET @DateAuxiliarTo = DATEFROMPARTS(DATEPART(YEAR, @DateAuxiliar), DATEPART(MONTH, @DateAuxiliar), @MonthDayPeriodTo)
				END TRY  
				BEGIN CATCH  
					SET @DateAuxiliarTo = DATEFROMPARTS(DATEPART(YEAR, @DateAuxiliar), DATEPART(MONTH, @DateAuxiliar), DATEPART(DAY, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@DateAuxiliar)+1,0)))) --Busco ultimo dia de ese mes porque si fallò asumo que es por eso
				END CATCH


				SET @DateAuxiliarFrom = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliarFrom), CAST(@SendingHour AS DATETIME))
				SET @DateAuxiliarTo = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliarTo), CAST(@SendingHour AS DATETIME))

				IF CAST(@DateAuxiliar AS DATE) >= @Today
				BEGIN
					IF NOT EXISTS(SELECT 1 FROM [ScheduleReportEmailsToSend] WHERE IdScheduleReport = @IdScheduleReport and [EmailSendDateTime] = Tzdb.ToUtc(@DateAuxiliar))
					BEGIN
						INSERT INTO [dbo].[ScheduleReportEmailsToSend]([IdScheduleReport], [DateFrom], [DateTo], [EmailSendDateTime])
						VALUES		(@IdScheduleReport, Tzdb.ToUtc(@DateAuxiliarFrom), Tzdb.ToUtc(@DateAuxiliarTo), Tzdb.ToUtc(@DateAuxiliar))
					END
				END


				SET @DateAuxiliar = DATEADD(MONTH, @RNumber, @DateAuxiliar)
				BEGIN TRY  
					SET @DateAuxiliar = DATEFROMPARTS(DATEPART(YEAR, @DateAuxiliar), DATEPART(MONTH, @DateAuxiliar), @MonthDayNumber) 
				END TRY  
				BEGIN CATCH  
					SET @DateAuxiliar = DATEFROMPARTS(DATEPART(YEAR, @DateAuxiliar), DATEPART(MONTH, @DateAuxiliar), DATEPART(DAY, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@DateAuxiliar)+1,0)))) --Busco ultimo dia de ese mes porque si fallò asumo que es por eso
				END CATCH 

				SET @DateAuxiliar = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliar), CAST(@SendingHour AS DATETIME)) --RealSatrtDate a la hora que se envia el formulario
			END 

		END
		ELSE
		BEGIN
			IF @MonthPeriodSentOption = 2 --El periodo a enviar es el mes anterior.
			BEGIN
			--El periodo a enviar es el del mes anterior al envio
			
			SET @DateAuxiliar = DATEADD(day, DATEDIFF(day, 0, @RealStartDate), CAST(@SendingHour AS DATETIME)) --RealSatrtDate a la hora que se envia el formulario

			WHILE CAST(@DateAuxiliar AS [sys].[date]) <= @TheoricalEndDateTruncated
			BEGIN		

				--Tengo que definir los DateFrom y los DateTo para el reporte.	
				SET @AuxiliarForOption2 = DATEADD(MONTH, -1, @DateAuxiliar)
				SET @DateAuxiliarFrom = DATEFROMPARTS(DATEPART(YEAR, @AuxiliarForOption2), DATEPART(MONTH, @AuxiliarForOption2), @MonthDayPeriodFrom)
				BEGIN TRY  
					SET @DateAuxiliarTo = DATEFROMPARTS(DATEPART(YEAR, @AuxiliarForOption2), DATEPART(MONTH, @AuxiliarForOption2), @MonthDayPeriodTo)
				END TRY  
				BEGIN CATCH  
					SET @DateAuxiliarTo = DATEFROMPARTS(DATEPART(YEAR, @AuxiliarForOption2), DATEPART(MONTH, @AuxiliarForOption2), DATEPART(DAY, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@AuxiliarForOption2)+1,0)))) --Busco ultimo dia de ese mes porque si fallò asumo que es por eso
				END CATCH


				SET @DateAuxiliarFrom = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliarFrom), CAST(@SendingHour AS DATETIME))
				SET @DateAuxiliarTo = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliarTo), CAST(@SendingHour AS DATETIME))

				IF CAST(@DateAuxiliar AS DATE) >= @Today
				BEGIN
					IF NOT EXISTS(SELECT 1 FROM [ScheduleReportEmailsToSend] WHERE IdScheduleReport = @IdScheduleReport and [EmailSendDateTime] = Tzdb.ToUtc(@DateAuxiliar))
					BEGIN
						INSERT INTO [dbo].[ScheduleReportEmailsToSend]([IdScheduleReport], [DateFrom], [DateTo], [EmailSendDateTime])
						VALUES		(@IdScheduleReport, Tzdb.ToUtc(@DateAuxiliarFrom), Tzdb.ToUtc(@DateAuxiliarTo), Tzdb.ToUtc(@DateAuxiliar))
					END
				END


				SET @DateAuxiliar = DATEADD(MONTH, @RNumber, @DateAuxiliar)
				BEGIN TRY  
					SET @DateAuxiliar = DATEFROMPARTS(DATEPART(YEAR, @DateAuxiliar), DATEPART(MONTH, @DateAuxiliar), @MonthDayNumber) 
				END TRY  
				BEGIN CATCH  
					SET @DateAuxiliar = DATEFROMPARTS(DATEPART(YEAR, @DateAuxiliar), DATEPART(MONTH, @DateAuxiliar), DATEPART(DAY, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@DateAuxiliar)+1,0)))) --Busco ultimo dia de ese mes porque si fallò asumo que es por eso
				END CATCH 

				SET @DateAuxiliar = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliar), CAST(@SendingHour AS DATETIME)) --RealSatrtDate a la hora que se envia el formulario
			END 

			END
			ELSE
			BEGIN
			--Se selecciono una fecha de inicio de datos, OPCION 3
			SET @DateAuxiliar = DATEADD(day, DATEDIFF(day, 0, @RealStartDate), CAST(@SendingHour AS DATETIME)) --RealSatrtDate a la hora que se envia el formulario

			WHILE CAST(@DateAuxiliar AS [sys].[date]) <= @TheoricalEndDateTruncated
			BEGIN		

				--Tengo que definir los DateFrom y los DateTo para el reporte.	
				SET @DateAuxiliarFrom = DATEFROMPARTS(DATEPART(YEAR, @MonthDayPeriodFromCalendar), 
				DATEPART(MONTH, @MonthDayPeriodFromCalendar), DATEPART(DAY, @MonthDayPeriodFromCalendar))		 
				
				SET @DateAuxiliarTo = @DateAuxiliar -- Es la fecha de envio del correo.

				SET @DateAuxiliarFrom = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliarFrom), CAST(@SendingHour AS DATETIME))
				SET @DateAuxiliarTo = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliarTo), CAST(@SendingHour AS DATETIME))

				IF CAST(@DateAuxiliar AS DATE) >= @Today
				BEGIN
					IF NOT EXISTS(SELECT 1 FROM [ScheduleReportEmailsToSend] WHERE IdScheduleReport = @IdScheduleReport 
					and [EmailSendDateTime] = Tzdb.ToUtc(@DateAuxiliar))
					BEGIN
						INSERT INTO [dbo].[ScheduleReportEmailsToSend]([IdScheduleReport], [DateFrom], [DateTo], [EmailSendDateTime])
						VALUES		(@IdScheduleReport, Tzdb.ToUtc(@DateAuxiliarFrom), Tzdb.ToUtc(@DateAuxiliarTo), Tzdb.ToUtc(@DateAuxiliar))
					END
				END


				SET @DateAuxiliar = DATEADD(MONTH, @RNumber, @DateAuxiliar)
				BEGIN TRY  
					SET @DateAuxiliar = DATEFROMPARTS(DATEPART(YEAR, @DateAuxiliar), DATEPART(MONTH, @DateAuxiliar), @MonthDayNumber) 
				END TRY  
				BEGIN CATCH  
					SET @DateAuxiliar = DATEFROMPARTS(DATEPART(YEAR, @DateAuxiliar), DATEPART(MONTH, @DateAuxiliar), DATEPART(DAY, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@DateAuxiliar)+1,0)))) --Busco ultimo dia de ese mes porque si fallò asumo que es por eso
				END CATCH 

				SET @DateAuxiliar = DATEADD(day, DATEDIFF(day, 0, @DateAuxiliar), CAST(@SendingHour AS DATETIME)) --RealSatrtDate a la hora que se envia el formulario
			END 
			END

		END
	END

	return

END
