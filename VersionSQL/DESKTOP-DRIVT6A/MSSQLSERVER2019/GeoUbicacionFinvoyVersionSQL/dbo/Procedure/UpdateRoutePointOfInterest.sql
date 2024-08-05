/****** Object:  Procedure [dbo].[UpdateRoutePointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 24/08/2015
-- Description:	SP para actualizar una visita a una ruta planificada
-- =============================================
CREATE PROCEDURE [dbo].[UpdateRoutePointOfInterest]
(
	 @EndDate [sys].DATETIME = NULL
	,@DaysOfWeek [sys].VARCHAR(20) = NULL
	,@IdPointOfInterest [sys].INT = NULL
    ,@IdRoutePointOfInterest [sys].[INT] = NULL
    ,@Comment [sys].[VARCHAR](230) = NULL
	,@RecurrenceCondition [sys].CHAR = NULL
	,@RecurrenceNumber [sys].[INT] = NULL
	,@FromHour [sys].[time](7) = NULL
	,@ToHour [sys].[time](7) = NULL
	,@Title [sys].[VARCHAR](250) = NULL
	,@TheoricalMinutes [sys].[int] = NULL

)
AS
BEGIN
	Declare @dayAux [sys].INT = NULL
	DECLARE @DatoToCompare [sys].DATETIME = NULL
	DECLARE @StartDate [sys].DATETIME = NULL
	DECLARE @StartDateAux [sys].DATETIME = NULL
	DECLARE @StartDateAux2 [sys].DATETIME = NULL

	----*****Busco ultimo dia ingresado para la ruta a procesar y actualizo la fecha de comienzo
	SELECT TOP	1 @StartDateAux = RD.[RouteDate]
	FROM		[dbo].[RouteDetail] RD WITH (NOLOCK)
	WHERE		RD.[IdRoutePointOfInterest] = @IdRoutePointOfInterest 
	ORDER BY	RD.[RouteDate] desc

	IF @StartDateAux < @EndDate
	BEGIN

		IF @RecurrenceCondition = 'D'
		BEGIN
			SET @DaysOfWeek = DATEPART(WEEKDAY, Tzdb.FromUtc(@StartDateAux))
			SET @StartDate = @StartDateAux
		END

		--******************************************
		--Inserto dias de la semana

		IF LEN(@DaysOfWeek) = 1
		BEGIN
			set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, 1, 1))  
			IF @RecurrenceCondition = 'W' OR @RecurrenceCondition = 'M'
			BEGIN
				SET @StartDate = @StartDateAux
			END

			EXEC [dbo].[CalculateAndUpdateRouteDetail] @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @IdRoutePointOfInterest, @ResultDate = @DatoToCompare OUTPUT, @FromHour = @FromHour, @ToHour = @ToHour, @Title = @Title, @TheoricalMinutes = @TheoricalMinutes
		END
		ELSE
		BEGIN
			DECLARE @pos INT = 0
			DECLARE @len INT = 0
			WHILE CHARINDEX(',', @DaysOfWeek, @pos)>0
			BEGIN
				set @len = CHARINDEX(',', @DaysOfWeek, @pos+1) - @pos
				set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, @len))
				
				IF @RecurrenceCondition = 'W' OR @RecurrenceCondition = 'M'
				BEGIN
					SELECT TOP	1 @StartDateAux2 = RD.[RouteDate]
					FROM		[dbo].[RouteDetail] RD WITH (NOLOCK)
					WHERE		RD.[IdRoutePointOfInterest] = @IdRoutePointOfInterest
								AND DATEPART(WEEKDAY, Tzdb.FromUtc(RD.[RouteDate])) = @dayAux
					ORDER BY	RD.[RouteDate] DESC
                			
					SET @StartDate = @StartDateAux2
				END

				EXEC [dbo].[CalculateAndUpdateRouteDetail] @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @IdRoutePointOfInterest, @ResultDate = @DatoToCompare OUTPUT, @FromHour = @FromHour, @ToHour = @ToHour, @Title = @Title, @TheoricalMinutes = @TheoricalMinutes
			
				SET @pos = CHARINDEX(',', @DaysOfWeek, @pos+@len) +1
			END
			--INSERTO EL ULTIMO

			SET @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, 1))  
			IF @RecurrenceCondition = 'W' OR @RecurrenceCondition = 'M'
			BEGIN
				SELECT TOP	1 @StartDateAux2 = RD.[RouteDate]
				FROM		[dbo].[RouteDetail] RD WITH (NOLOCK)
				WHERE		RD.[IdRoutePointOfInterest] = @IdRoutePointOfInterest 
							AND DATEPART(WEEKDAY, Tzdb.FromUtc(RD.[RouteDate])) = @dayAux
				ORDER BY	RD.[RouteDate] DESC              			
			
				SET @StartDate = @StartDateAux2
			END

			EXEC [dbo].[CalculateAndUpdateRouteDetail] @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @IdRoutePointOfInterest, @ResultDate = @DatoToCompare OUTPUT, @FromHour = @FromHour, @ToHour = @ToHour, @Title = @Title, @TheoricalMinutes = @TheoricalMinutes
		END
	END
END
