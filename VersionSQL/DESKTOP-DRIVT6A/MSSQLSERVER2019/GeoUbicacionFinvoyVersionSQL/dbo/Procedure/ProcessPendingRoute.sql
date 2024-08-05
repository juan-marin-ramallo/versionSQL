/****** Object:  Procedure [dbo].[ProcessPendingRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 11/11/2015
-- Description:	SP para procesar una ruta
-- =============================================
CREATE PROCEDURE [dbo].[ProcessPendingRoute]
(
	 @IdRoute [sys].[INT] = NULL
    ,@StartDate [sys].DATETIME = NULL
	,@EndDate [sys].DATETIME = NULL
	,@DaysOfWeek [sys].VARCHAR(20) = NULL
	,@IdPointOfInterest [sys].INT = NULL
    ,@IdPersonOfInterest [sys].[INT] = NULL
	,@RecurrenceCondition [sys].CHAR = NULL
	,@RecurrenceNumber [sys].[INT] = NULL
)
AS
BEGIN
	Declare @dayAux [sys].INT = NULL
	DECLARE @DatoToCompare [sys].DATETIME = NULL
	DECLARE @StartDateAux [sys].DATETIME = NULL
	DECLARE @StartDateAux2 [sys].DATETIME = NULL

	----*****Busco ultimo dia ingresado para la ruta a procesar y actualizo la fecha de comienzo
	--SELECT TOP 1 @StartDateAux = RD.[RouteDate]
	--FROM   [dbo].[RouteDetail] RD
	--WHERE  RD.[IdRoute] = @IdRoute 
	--ORDER BY RD.[RouteDate] desc

	
	--IF @RecurrenceCondition = 'D'
	--BEGIN
	--	SET @DaysOfWeek = DATEPART(WEEKDAY, @StartDate)
	--	SET @StartDate = @StartDateAux
	--END

	----******************************************
	----Inserto dias de la semana

	--IF LEN(@DaysOfWeek) = 1
	--BEGIN
	--	set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, 1, 1))  
	--	IF @RecurrenceCondition = 'W' OR @RecurrenceCondition = 'M'
	--	BEGIN
	--		SET @StartDate = @StartDateAux
	--	END

	--	EXEC CalculateAndSaveRouteDetailProccessService @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @IdRoute, @ResultDate = @DatoToCompare OUTPUT
	--END
 --   ELSE
 --   BEGIN
	--	DECLARE @pos INT = 0
	--	DECLARE @len INT = 0
	--	WHILE CHARINDEX(',', @DaysOfWeek, @pos)>0
	--	BEGIN
	--		set @len = CHARINDEX(',', @DaysOfWeek, @pos+1) - @pos
	--		set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, @len))
	--		IF @RecurrenceCondition = 'W' OR @RecurrenceCondition = 'M'
	--		BEGIN
	--			SELECT TOP 1 @StartDateAux2 = RD.[RouteDate]
	--			FROM   [dbo].[RouteDetail] RD
	--			INNER JOIN dbo.Route R ON R.Id=RD.IdRoute
	--			WHERE  RD.[IdRoute] = @IdRoute AND DATEPART(WEEKDAY,RD.RouteDate) = @dayAux
	--			ORDER BY RD.[RouteDate] DESC
                			
	--			SET @StartDate = @StartDateAux2
	--		END

	--		EXEC CalculateAndSaveRouteDetailProccessService @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @IdRoute, @ResultDate = @DatoToCompare OUTPUT
			
	--		SET @pos = CHARINDEX(',', @DaysOfWeek, @pos+@len) +1
	--	END
	--	--INSERTO EL ULTIMO
	--	set @dayAux = CONVERT(int, SUBSTRING(@DaysOfWeek, @pos, 1))  
	--	IF @RecurrenceCondition = 'W' OR @RecurrenceCondition = 'M'
	--	BEGIN
	--		SELECT TOP 1 @StartDateAux2 = RD.[RouteDate]
	--		FROM   [dbo].[RouteDetail] RD
	--		INNER JOIN dbo.Route R ON R.Id=RD.IdRoute
	--		WHERE  RD.[IdRoute] = @IdRoute AND DATEPART(WEEKDAY,RD.RouteDate) = @dayAux
	--		ORDER BY RD.[RouteDate] DESC              			
			
	--		SET @StartDate = @StartDateAux2
	--	END

	--	EXEC CalculateAndSaveRouteDetailProccessService @TheoricalStartDate = @StartDate,@TheoricalEndDate = @EndDate,@RCondition = @RecurrenceCondition,@RNumber = @RecurrenceNumber,@Day = @dayAux,@IdPlannedRoute = @IdRoute, @ResultDate = @DatoToCompare OUTPUT
	--END
	
END
