/****** Object:  Procedure [dbo].[UpdateRecurrentRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 29/06/2015
-- Description:	SP para actualizar una ruta recurrente
-- =============================================
CREATE PROCEDURE [dbo].[UpdateRecurrentRoute]
(
     @PersonAlreadyStartDay [sys].[bit] OUTPUT
	,@DeviceId [sys].[varchar](300) OUTPUT
	,@IdRoute [sys].INT = NULL
	,@StartDate [sys].DATETIME = NULL
	,@EndDate [sys].DATETIME = NULL
	,@DaysOfWeek [sys].VARCHAR(20) = NULL
	,@IdPointOfInterest [sys].[INT] = NULL
    ,@IdPersonOfInterest [sys].[INT] = NULL
    ,@Comment [sys].[VARCHAR](1000) = NULL
	,@RecurrenceCondition [sys].CHAR = NULL
	,@RecurrenceNumber [sys].[INT] = NULL
	,@EditedDate [sys].DATETIME = NULL
)
AS
BEGIN
	
	DECLARE @NewRouteId [sys].INT
	DECLARE @DatoToCompare [sys].DATETIME = NULL
	Declare @dayAux [sys].INT = NULL

	-- Si la fecha de comienzo de la ruta es menor que la actual, tomo la actual como la fecha de comienzo.
	--IF CAST(@StartDate AS [sys].[date]) < CAST(GETUTCDATE() AS [sys].[date]) 
	--BEGIN
	--	SET @StartDate = GETUTCDATE() 
	--END

	----Copio registro de ruta
	--INSERT INTO dbo.Route 
	--(IdPersonOfInterest, IdPointOfInterest, StartDate, EndDate, Comment, RecurrenceCondition,
	--RecurrenceNumber, EditedDate, AlternativeRoute, Deleted)
	--VALUES (@IdPersonOfInterest, @IdPointOfInterest, @StartDate, @EndDate, @Comment,
	--@RecurrenceCondition, @RecurrenceNumber, @EditedDate, 0, 0)

	--SET @NewRouteId = SCOPE_IDENTITY()
	
	----Borro ruta nodificada
	--UPDATE Route 
	--SET EditedDate = GETUTCDATE(), EndDate = GETUTCDATE()
	--WHERE Id = @IdRoute

	----Elimino todas las rutas que haya en RouteDetail posteriores a la fecha actual.
	--DELETE FROM dbo.[RouteDetail]
	--WHERE IdRoute = @IdRoute AND CAST(RouteDate AS DATE) >= CAST(GETUTCDATE() AS DATE)

	----******************************************

	----Inserto dias de la semana.

	--IF LEN(@DaysOfWeek) = 1
	--BEGIN
	--	set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, 1, 1))  
	--	INSERT INTO [dbo].RouteDayOfWeek(IdRoute, DayOfWeek)
	--	VALUES  (@NewRouteId, @dayAux)
	--	EXEC CalculateAndSaveRouteDetail @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @NewRouteId, @ResultDate = @DatoToCompare OUTPUT
	--	IF datediff(day, @DatoToCompare, (select TOP 1 m.[date] FROM Mark m
	--		where m.idPersonOfInterest = @IdPersonOfInterest AND m.[type] = 'E' 
	--		order by m.id desc)) = 0 
        
	--			BEGIN
	--				SET @PersonAlreadyStartDay = 1
	--			END
	--			ELSE
	--			BEGIN
	--				SET @PersonAlreadyStartDay = 0
	--			END
	--END
 --   ELSE
 --   BEGIN
	--	DECLARE @pos INT = 0
	--	DECLARE @len INT = 0

	--	WHILE CHARINDEX(',', @DaysOfWeek, @pos)>0
	--	BEGIN
	--		set @len = CHARINDEX(',', @DaysOfWeek, @pos+1) - @pos
	--		set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, @len))
        
	--		INSERT INTO [dbo].RouteDayOfWeek(IdRoute, DayOfWeek)
	--			VALUES  (@NewRouteId, @dayAux) 

	--		EXEC CalculateAndSaveRouteDetail @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @NewRouteId, @ResultDate = @DatoToCompare OUTPUT

	--		IF datediff(day, @DatoToCompare, (select TOP 1 m.[date] FROM Mark m
	--		where m.idPersonOfInterest = @IdPersonOfInterest AND m.[type] = 'E' 
	--		order by m.id desc)) = 0 
        
	--			BEGIN
	--				SET @PersonAlreadyStartDay = 1
	--			END
	--			ELSE
	--			BEGIN
	--				SET @PersonAlreadyStartDay = 0
	--			END


	--		set @pos = CHARINDEX(',', @DaysOfWeek, @pos+@len) +1
	--	END
	--	--INSERTO EL ULTIMO
	--	set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, 1))  
	--	INSERT INTO [dbo].RouteDayOfWeek(IdRoute, DayOfWeek)
	--	VALUES  (@NewRouteId, @dayAux)
	--	EXEC CalculateAndSaveRouteDetail @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @NewRouteId, @ResultDate = @DatoToCompare OUTPUT
	--	IF datediff(day, @DatoToCompare, (select TOP 1 m.[date] FROM Mark m
	--		where m.idPersonOfInterest = @IdPersonOfInterest AND m.[type] = 'E' 
	--		order by m.id desc)) = 0 
        
	--			BEGIN
	--				SET @PersonAlreadyStartDay = 1
	--			END
	--			ELSE
	--			BEGIN
	--				SET @PersonAlreadyStartDay = 0
	--			END
	--END
    
	--************************************************

END
