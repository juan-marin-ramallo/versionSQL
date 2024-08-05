/****** Object:  Procedure [dbo].[CalculateAndSaveRouteDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 16/06/2015
-- Description:	SP para calcular y guardar rutas por seis meses a partir de la fecha de comienzo
-- =============================================
CREATE PROCEDURE [dbo].[CalculateAndSaveRouteDetail]
(
     @TheoricalStartDate [sys].DATETIME = NULL,
	 @TheoricalEndDate [sys].DATETIME = NULL,
	 @RCondition [sys].CHAR = NULL,
	 @RNumber [sys].int = NULL,
	 @Day [sys].INT = NULL,
	 @IdPlannedRoute [sys].INT = NULL,
	 @ResultDate [sys].DATETIME	OUTPUT,
	 @FromHour [sys].[time](7) = NULL,
	 @ToHour [sys].[time](7) = NULL,
	 @Title [sys].[VARCHAR](250) = NULL,
	 @TheoricalMinutes [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @TodayDate [sys].[DATE] = Tzdb.FromUtc(GETUTCDATE())

	IF @TheoricalStartDate IS NOT NULL
	BEGIN
		SET @TheoricalStartDate = Tzdb.FromUtc(@TheoricalStartDate)
	END

	DECLARE @TheoricalEndDateTruncated [sys].[date]
	IF @TheoricalEndDate IS NOT NULL
	BEGIN
		SET @TheoricalEndDateTruncated = Tzdb.FromUtc(@TheoricalEndDate)
	END

	DECLARE @RealStartDate [sys].DATETIME
	DECLARE @DateAuxiliar [sys].DATE
	DECLARE @DayOfWeekMonth [sys].INT

	--Calculo comienzo real verificando la fecha
	;WITH myWeek AS
	(
		SELECT @TheoricalStartDate AS myDay, DATEPART(WEEKDAY, @TheoricalStartDate) as MyDayofWeek
		UNION ALL
		SELECT DATEADD(DAY, 1, myDay) AS myDay,  DATEPART(WEEKDAY, DATEADD(DAY, 1, myDay)) as MyDayofWeek 
		FROM myWeek WHERE DATEDIFF(DAY, @TheoricalStartDate, myday) < 6
	)
	SELECT @RealStartDate = myDay FROM myWeek WHERE MyDayofWeek = @Day

	SET @DateAuxiliar = @RealStartDate

	IF @RCondition = 'D'
	BEGIN
		WHILE @DateAuxiliar <= @TheoricalEndDateTruncated
		BEGIN
			IF @DateAuxiliar >= @TodayDate
			BEGIN
				INSERT INTO [dbo].[RouteDetail]([RouteDate], [IdRoutePointOfInterest], [Disabled], [NoVisited], [FromHour], [ToHour], [Title], [TheoricalMinutes])
				VALUES		(Tzdb.ToUtc(@DateAuxiliar), @IdPlannedRoute, 0, 0, @FromHour, @ToHour, @Title, @TheoricalMinutes)
			END
			SET @DateAuxiliar = DATEADD(DAY, @RNumber, @DateAuxiliar)
        END 
	END

	IF @RCondition = 'W'
	BEGIN
		WHILE @DateAuxiliar <= @TheoricalEndDateTruncated
		BEGIN
			IF @DateAuxiliar >= @TodayDate
			BEGIN
				INSERT INTO [dbo].[RouteDetail]([RouteDate], [IdRoutePointOfInterest], [Disabled], [NoVisited], [FromHour], [ToHour], [Title], [TheoricalMinutes])
				VALUES		(Tzdb.ToUtc(@DateAuxiliar), @IdPlannedRoute, 0, 0, @FromHour, @ToHour, @Title, @TheoricalMinutes)
			END
			SET @DateAuxiliar = DATEADD(WEEK, @RNumber, @DateAuxiliar)
        END 
	END

	IF @RCondition = 'M'
	BEGIN
		DECLARE @NextMonth [sys].DATETIME
		--Tengo que saber que dia del mes es la fecha de comienzo real (Por ejemplo: Segundo lunes del mes)
		SET @DayOfWeekMonth  = [dbo].[GetWeekdayAndNths](@RealStartDate,'M')
		--Tengo que calcular las fechas para que coincidan con la funcion. En mi criterio Domingo = 1. EN EL DE LA FUNCION DOMINGO = 7
		IF @Day = 1
		BEGIN
			SET @Day = 7
        END
        ELSE
        BEGIN
			SET @Day = @Day - 1
        END
		WHILE @DateAuxiliar <= @TheoricalEndDateTruncated
		BEGIN		
			IF @DateAuxiliar >= @TodayDate
			BEGIN
				INSERT INTO [dbo].[RouteDetail]([RouteDate], [IdRoutePointOfInterest], [Disabled], [NoVisited], [FromHour], [ToHour], [Title], [TheoricalMinutes])
				VALUES  (Tzdb.ToUtc(@DateAuxiliar), @IdPlannedRoute, 0, 0, @FromHour, @ToHour, @Title, @TheoricalMinutes)
			END
			--Tengo que ver cual es el numero del dia buscado en el siguiente mes
			SET @NextMonth = DATEADD(MONTH, 1, @DateAuxiliar)

			--Busco la fecha de la siguiente ruta a realizar en base al numero del dis         
			--Si el dia a buscar es el 5to dia del mes, puede ser que no lo encuentre. En ese caso hay que buscar la 4ta ocurrencia.
			IF [dbo].[GetNthWeekdayOfMonth](@NextMonth,@Day,@DayOfWeekMonth) IS NOT NULL
			BEGIN
				SET @DateAuxiliar = [dbo].[GetNthWeekdayOfMonth](@NextMonth,@Day,@DayOfWeekMonth) 	
			END
			ELSE
			BEGIN
				SET @DateAuxiliar = [dbo].[GetNthWeekdayOfMonth](@NextMonth,@Day,@DayOfWeekMonth - 1)  
			END
        END 
	END

	SET @ResultDate = Tzdb.ToUtc(@RealStartDate)
	return
	
END
