/****** Object:  Procedure [dbo].[SaveRoutePointOfInterestExcel]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 02/09/2016
-- Description:	SP para guardar una ruta recurrente por excel
-- =============================================
CREATE PROCEDURE [dbo].[SaveRoutePointOfInterestExcel]
(
	 @IdRoutePointOfInterest [sys].[int] = 0 output
	,@StartDate [sys].DATETIME = NULL
	,@EndDate [sys].DATETIME = NULL
	,@DaysOfWeek [sys].VARCHAR(20) = NULL
	,@PointOfInterestIdentifier [sys].varchar(50)
    ,@IdRouteGroup [sys].[INT] = NULL
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
	DECLARE @IdPointOfInterest [sys].[INT]
	SET @IdPointOfInterest = (SELECT TOP (1) Id FROM dbo.[PointOfInterest] WITH (NOLOCK) WHERE [Identifier] = @PointOfInterestIdentifier AND Deleted = 0)

	IF @IdPointOfInterest IS NOT NULL
	BEGIN
		--SET @IdRoutePointOfInterest = (SELECT TOP (1) Id FROM dbo.[RoutePointOfInterest] 
		--WHERE [IdRouteGroup] = @IdRouteGroup AND [IdPointOfInterest] = @IdPointOfInterest AND [Deleted] = 0
		--		AND [RecurrenceNumber] = @RecurrenceNumber AND [RecurrenceCondition] = @RecurrenceCondition)
		--IF @IdRoutePointOfInterest IS NULL
		--BEGIN
			DECLARE @DatoToCompare [sys].DATETIME = NULL
			DECLARE @dayAux [sys].INT = NULL
			DECLARE @IdPersonOfInterest [sys].INT = (SELECT IdPersonOfInterest FROM [dbo].[RouteGroup] WITH (NOLOCK) WHERE [Id] = @IdRouteGroup)
    
			--******************************************
			--Primero inserto en la tabla RoutePointOfInterest
			INSERT INTO [dbo].[RoutePointOfInterest]
					( [IdPointOfInterest] ,
					  [Comment] ,
					  [RecurrenceCondition] ,
					  [RecurrenceNumber] ,
					  [AlternativeRoute],
					  [IdRouteGroup],
					  [Deleted],
					  [EditedDate]
					)
			VALUES  ( @IdPointOfInterest, 
					  @Comment ,
					  @RecurrenceCondition , -- 
					  @RecurrenceNumber , 
					  0,
					  @IdRouteGroup,
					  0,
					  GETUTCDATE()
					)
	
			SELECT @IdRoutePointOfInterest = SCOPE_IDENTITY()
			--******************************************
	
			----******************************************
			----Inserto dias de la semana

			IF LEN(@DaysOfWeek) = 1
			BEGIN
				set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, 1, 1))  

				INSERT INTO [dbo].[RouteDayOfWeek]([IdRoutePointOfInterest], [DayOfWeek])
				VALUES		(@IdRoutePointOfInterest, @dayAux)
		
				EXEC CalculateAndSaveRouteDetail @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @IdRoutePointOfInterest, @ResultDate = @DatoToCompare OUTPUT, @FromHour = @FromHour, @ToHour = @ToHour, @Title = @Title, @TheoricalMinutes = @TheoricalMinutes
			END
			ELSE
			BEGIN
				DECLARE @pos INT = 0
				DECLARE @len INT = 0

				WHILE CHARINDEX(',', @DaysOfWeek, @pos)>0
				BEGIN
					set @len = CHARINDEX(',', @DaysOfWeek, @pos+1) - @pos
					set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, @len))
        
					INSERT INTO [dbo].[RouteDayOfWeek]([IdRoutePointOfInterest], [DayOfWeek])
						VALUES  (@IdRoutePointOfInterest, @dayAux) 

					EXEC CalculateAndSaveRouteDetail @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @IdRoutePointOfInterest, @ResultDate = @DatoToCompare OUTPUT, @FromHour = @FromHour, @ToHour = @ToHour, @Title = @Title, @TheoricalMinutes = @TheoricalMinutes

					set @pos = CHARINDEX(',', @DaysOfWeek, @pos+@len) +1
				END

				--INSERTO EL ULTIMO
				set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, 1))  
		
				INSERT INTO [dbo].[RouteDayOfWeek]([IdRoutePointOfInterest], [DayOfWeek])	
				VALUES		(@IdRoutePointOfInterest, @dayAux)
		
				EXEC CalculateAndSaveRouteDetail @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @IdRoutePointOfInterest, @ResultDate = @DatoToCompare OUTPUT, @FromHour = @FromHour, @ToHour = @ToHour, @Title = @Title, @TheoricalMinutes = @TheoricalMinutes
			END
    
			----************************************************
		--END
	END
	ELSE
	BEGIN
		SET @IdRoutePointOfInterest = 0
	END
END
