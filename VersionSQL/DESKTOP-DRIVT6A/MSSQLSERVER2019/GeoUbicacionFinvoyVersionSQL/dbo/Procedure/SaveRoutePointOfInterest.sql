/****** Object:  Procedure [dbo].[SaveRoutePointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 23/08/2016
-- Description:	SP para guardar una ruta recurrente
-- =============================================
CREATE PROCEDURE [dbo].[SaveRoutePointOfInterest]
(
     @PersonAlreadyStartDay [sys].[bit] OUTPUT
	,@DeviceId [sys].[varchar](300) OUTPUT
	,@StartDate [sys].DATETIME = NULL
	,@EndDate [sys].DATETIME = NULL
	,@DaysOfWeek [sys].VARCHAR(20) = NULL
	,@IdPointOfInterest [sys].INT = NULL
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

	DECLARE @IdRoutePointOfInterest [sys].[int] = 0
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
		
		IF Tzdb.AreSameSystemDates(@DatoToCompare, (SELECT TOP 1 M.[Date] FROM [dbo].[Mark] M WITH (NOLOCK)
													WHERE M.[IdPersonOfInterest] = @IdPersonOfInterest AND M.[Type] = 'E' 
													ORDER BY M.[Id] desc)) = 1      
		BEGIN
			SET @PersonAlreadyStartDay = 1
		END
		ELSE
		BEGIN
			SET @PersonAlreadyStartDay = 0
		END
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

				IF Tzdb.AreSameSystemDates(@DatoToCompare, (SELECT TOP 1 M.[Date] FROM [dbo].[Mark] M WITH (NOLOCK)
															WHERE M.[IdPersonOfInterest] = @IdPersonOfInterest AND M.[Type] = 'E' 
															ORDER BY M.[Id] desc)) = 1       
				BEGIN
					SET @PersonAlreadyStartDay = 1
				END
				ELSE
				BEGIN
					SET @PersonAlreadyStartDay = 0
				END

			set @pos = CHARINDEX(',', @DaysOfWeek, @pos+@len) +1
		END

		--INSERTO EL ULTIMO
		set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, 1))  
		
		INSERT INTO [dbo].[RouteDayOfWeek]([IdRoutePointOfInterest], [DayOfWeek])	
		VALUES		(@IdRoutePointOfInterest, @dayAux)
		
		EXEC CalculateAndSaveRouteDetail @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @IdRoutePointOfInterest, @ResultDate = @DatoToCompare OUTPUT, @FromHour = @FromHour, @ToHour = @ToHour, @Title = @Title, @TheoricalMinutes = @TheoricalMinutes
		
		IF Tzdb.AreSameSystemDates(@DatoToCompare, (SELECT TOP 1 M.[Date] FROM [dbo].[Mark] M WITH (NOLOCK)
													WHERE M.[IdPersonOfInterest] = @IdPersonOfInterest AND M.[Type] = 'E' 
													ORDER BY M.[Id] desc)) = 1      
		BEGIN
			SET @PersonAlreadyStartDay = 1
		END
		ELSE
		BEGIN
			SET @PersonAlreadyStartDay = 0
		END
	END
    
	----************************************************

	
	SET @DeviceId = (SELECT TOP 1 [DeviceId] 
	FROM [dbo].[PersonOfInterest] WITH (NOLOCK)
	WHERE [Id] = @IdPersonOfInterest AND [DeviceId] IS NOT NULL)
	
END
