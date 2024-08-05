/****** Object:  Procedure [dbo].[UpdateEndDateAllPlannedRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 21/12/2018
-- Description:	SP para actualizar fecha de fin de todas las rutas planificadas
-- =============================================
CREATE PROCEDURE [dbo].[UpdateEndDateAllPlannedRoute]
(
	@EndDate [sys].DATETIME = NULL
	,@ResultCode [sys].[int] OUTPUT
)
AS
BEGIN

SET @ResultCode = 0

IF @EndDate IS NOT NULL
BEGIN
	
	BEGIN TRANSACTION;
    SAVE TRANSACTION UpdateEndDateCompleted;
	BEGIN TRY
		DECLARE @routeGroup_id int
		DECLARE @routeGroup_endDate [sys].[datetime]
		DECLARE @routePointOfInterest_id int
		DECLARE @routeDayOfWeek_day int

		DECLARE @IdRoutePointOfInterest [sys].[INT] = NULL
		DECLARE @IdPointOfInterest [sys].INT = NULL
				,@Comment [sys].[VARCHAR](230) = NULL
				,@RecurrenceCondition [sys].CHAR = NULL
				,@RecurrenceNumber [sys].[INT] = NULL
				--,@DaysOfWeek [sys].VARCHAR(20) = NULL

		DECLARE @dayAux [sys].INT = NULL
		DECLARE @DatoToCompare [sys].DATETIME = NULL
		DECLARE @StartDate [sys].DATETIME = NULL
		DECLARE @StartDateAux [sys].DATETIME = NULL
		DECLARE @StartDateAux2 [sys].DATETIME = NULL
		DECLARE @DaysOfWeek [sys].VARCHAR(20) = NULL

		DECLARE routeGroup_cursor CURSOR FOR   
		SELECT	[Id], [EndDate]
		FROM	[dbo].[RouteGroup] 
		WHERE	[Deleted] = 0  AND cast([EndDate] as date) >= cast(GETUTCDATE() as date)

		OPEN routeGroup_cursor  

		FETCH NEXT FROM routeGroup_cursor   
		INTO @routeGroup_id, @routeGroup_endDate

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			UPDATE	[dbo].[RouteGroup]	
			SET		[EndDate] = @EndDate, [EditedDate] = GETUTCDATE()	
			WHERE	[Id] = @routeGroup_id	

			--Actualizar visitas
			IF @routeGroup_endDate > @EndDate --Si nueva fecha de fin es menor a la que estaba elimino lo que hay despues
			BEGIN
				DELETE FROM [dbo].[RouteDetail]
				WHERE		[RouteDate] > @EndDate AND [IdRoutePointOfInterest] 
							IN (SELECT [Id] FROM [dbo].[RoutePointOfInterest] WHERE [IdRouteGroup] = @routeGroup_id AND [AlternativeRoute] = 0)
			END


			--Empiezo a actualizar los RoutePointOfInterest
			--Busco todos y los recorro
			DECLARE routePointOfInterest_cursor CURSOR FOR   
			SELECT	[Id] 
			FROM	[dbo].[RoutePointOfInterest] 
			WHERE	[Deleted] = 0  AND [IdRouteGroup] = @routeGroup_id AND [AlternativeRoute] = 0

			OPEN routePointOfInterest_cursor  

			FETCH NEXT FROM routePointOfInterest_cursor   
			INTO @routePointOfInterest_id

			WHILE @@FETCH_STATUS = 0  
			BEGIN  

				SET @IdRoutePointOfInterest = @routePointOfInterest_id

				SELECT	@RecurrenceCondition = rp.[RecurrenceCondition], @RecurrenceNumber = rp.[RecurrenceNumber],
						@IdPointOfInterest = rp.[IdPointOfInterest]				
				FROM	[dbo].[RoutePointOfInterest] rp
				WHERE	[Id] = @routePointOfInterest_id

				----*****Busco ultimo dia ingresado para la ruta a procesar y actualizo la fecha de comienzo
				SELECT TOP	1 @StartDateAux = RD.[RouteDate]
				FROM		[dbo].[RouteDetail] RD
				WHERE		RD.[IdRoutePointOfInterest] = @routePointOfInterest_id 
				ORDER BY	RD.[RouteDate] desc

				IF @RecurrenceCondition = 'D'
				BEGIN
					SET @DaysOfWeek = DATEPART(WEEKDAY, Tzdb.FromUtc(@StartDateAux))
					SET @StartDate = @StartDateAux
					set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, 1, 1)) 

					EXEC [dbo].[CalculateAndUpdateRouteDetail] @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @IdRoutePointOfInterest, @ResultDate = @DatoToCompare OUTPUT
				END
				ELSE
				BEGIN
					IF @StartDateAux < @EndDate
					BEGIN
						DECLARE routeDayOfWeek_cursor CURSOR FOR   
						SELECT	[DayOfWeek] 
						FROM	[dbo].[RouteDayOfWeek] 
						WHERE	[IdRoutePointOfInterest] = @routePointOfInterest_id

						OPEN routeDayOfWeek_cursor  

						FETCH NEXT FROM routeDayOfWeek_cursor   
						INTO @routeDayOfWeek_day

						WHILE @@FETCH_STATUS = 0  
						BEGIN

							SET @dayAux = @routeDayOfWeek_day

							SELECT TOP	1 @StartDateAux2 = RD.[RouteDate]
							FROM		[dbo].[RouteDetail] RD
							WHERE		RD.[IdRoutePointOfInterest] = @IdRoutePointOfInterest
										AND DATEPART(WEEKDAY, Tzdb.FromUtc(RD.[RouteDate])) = @dayAux
							ORDER BY	RD.[RouteDate] DESC
                			
							SET @StartDate = @StartDateAux2

							EXEC [dbo].[CalculateAndUpdateRouteDetail] @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @IdRoutePointOfInterest, @ResultDate = @DatoToCompare OUTPUT

							FETCH NEXT FROM routeDayOfWeek_cursor   
							INTO @routeDayOfWeek_day
						END
						CLOSE routeDayOfWeek_cursor;
						DEALLOCATE routeDayOfWeek_cursor  
					END
				END

				FETCH NEXT FROM routePointOfInterest_cursor   
				INTO @routePointOfInterest_id 

			end
			CLOSE routePointOfInterest_cursor
			DEALLOCATE routePointOfInterest_cursor
		  
			FETCH NEXT FROM routeGroup_cursor   
			INTO @routeGroup_id, @routeGroup_endDate
		END   
		CLOSE routeGroup_cursor
		DEALLOCATE routeGroup_cursor;
	END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
			SET @ResultCode = 1
            ROLLBACK TRANSACTION UpdateEndDateCompleted; -- rollback to UpdateEndDateCompleted
        END
    END CATCH
    COMMIT TRANSACTION 
END

END
