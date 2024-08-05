/****** Object:  Procedure [dbo].[CalculateAndUpdateRouteDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 24/08/2016
-- Description:	SP para calcular y guardar visitas cuando son modificadas
-- =============================================
CREATE PROCEDURE [dbo].[CalculateAndUpdateRouteDetail]
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
	
	IF @RCondition = 'D'
	BEGIN
		SET @RealStartDate = DATEADD(DAY, @RNumber, @TheoricalStartDate)
	END

	IF @RCondition = 'W'
	BEGIN
		SET @RealStartDate = DATEADD(WEEK, @RNumber, @TheoricalStartDate)
	END
    
	SET @DateAuxiliar = @RealStartDate

	IF @RCondition = 'D'
	BEGIN
		WHILE @DateAuxiliar <= @TheoricalEndDateTruncated
		BEGIN
			
			INSERT INTO [dbo].[RouteDetail]([RouteDate], [IdRoutePointOfInterest], [Disabled], 
						[NoVisited], [FromHour], [ToHour], [Title], [TheoricalMinutes])
			VALUES		(Tzdb.ToUtc(@DateAuxiliar), @IdPlannedRoute, 0, 0, @FromHour, @ToHour,@Title,@TheoricalMinutes)
			
			SET			@DateAuxiliar = DATEADD(DAY, @RNumber, @DateAuxiliar)
        END 
	END

	IF @RCondition = 'W'
	BEGIN
		WHILE @DateAuxiliar <= @TheoricalEndDateTruncated
		BEGIN
			
			INSERT INTO [dbo].[RouteDetail]([RouteDate], [IdRoutePointOfInterest], [Disabled], 
						[NoVisited], [FromHour], [ToHour], [Title], [TheoricalMinutes])
			VALUES		(Tzdb.ToUtc(@DateAuxiliar), @IdPlannedRoute, 0, 0, @FromHour, @ToHour,@Title,@TheoricalMinutes)
			
			SET @DateAuxiliar = DATEADD(WEEK, @RNumber, @DateAuxiliar)
        END 
	END

	IF @RCondition = 'M'
	BEGIN
		DECLARE @NextMonth [sys].DATETIME
		SET @DayOfWeekMonth  = [dbo].[GetWeekdayAndNths](@RealStartDate,'M')
		
		IF @Day = 1
		BEGIN
			SET @Day = 7
        END
        ELSE
        BEGIN
			SET @Day = @Day - 1
        END
		--Tengo que ver cual es el numero del dia buscado en el siguiente mes
		SET @NextMonth = DATEADD(MONTH, @RNumber, @DateAuxiliar)
        
		--Si el dia a buscar es el 5to dia del mes, puede ser que no lo encuentre. En ese caso hay que buscar la 4ta ocurrencia.
		IF [dbo].[GetNthWeekdayOfMonth](@NextMonth,@Day,@DayOfWeekMonth) IS NOT NULL
		BEGIN
			SET @DateAuxiliar = [dbo].[GetNthWeekdayOfMonth](@NextMonth,@Day,@DayOfWeekMonth) 	
		END
		ELSE
		BEGIN
			SET @DateAuxiliar = [dbo].[GetNthWeekdayOfMonth](@NextMonth,@Day,@DayOfWeekMonth - 1)  
		END

		WHILE @DateAuxiliar <= @TheoricalEndDateTruncated
		BEGIN		
			INSERT INTO [dbo].[RouteDetail]([RouteDate], [IdRoutePointOfInterest], [Disabled], 
						[NoVisited], [FromHour], [ToHour], [Title], [TheoricalMinutes])
			VALUES		(Tzdb.ToUtc(@DateAuxiliar), @IdPlannedRoute, 0, 0, @FromHour, @ToHour,@Title,@TheoricalMinutes)

			--Tengo que ver cual es el numero del dia buscado en el siguiente mes
			SET @NextMonth = DATEADD(MONTH, @RNumber, @DateAuxiliar)
			--Busco la fecha de la siguiente ruta a realizar en base al numero del dia      
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
