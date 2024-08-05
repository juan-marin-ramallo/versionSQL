/****** Object:  Procedure [dbo].[SaveSinglePlannedRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 23/08/2017
-- Description:	SP para guardar una ruta ALTERNATIVA que no tiene ruta palnificada como padre
-- =============================================
CREATE PROCEDURE [dbo].[SaveSinglePlannedRoute]
(
	 @Id [sys].[int] = 0 OUTPUT
    ,@PersonAlreadyStartDay [sys].[bit] OUTPUT
	,@DeviceId [sys].[varchar](300) OUTPUT
	,@Date [sys].DATETIME
	,@IdPersonOfInterest [sys].[INT]
	,@IdPointOfInterest [sys].[INT]
	,@DayOfWeek [sys].[INT]
    ,@Comment [sys].[VARCHAR](230) = NULL
	,@RouteName [sys].VARCHAR(50) = NULL
	,@FromHour [sys].[time](7) = NULL
	,@ToHour [sys].[time](7) = NULL
	,@Title [sys].[VARCHAR](250) = NULL
	,@TheoricalMinutes [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @Now [sys].[datetime]
	SET @Now = GETUTCDATE()

	DECLARE @IdRoutePointOfInterest [sys].[INT]
	DECLARE @IdRouteGroup [sys].[INT] = 0

	SET @IdRouteGroup = (SELECT TOP 1 [Id] FROM [dbo].[RouteGroup] WITH (NOLOCK) WHERE [IdPersonOfInterest] = @IdPersonOfInterest AND [Deleted] = 0
						AND Tzdb.IsLowerOrSameSystemDate([StartDate], @Date) = 1 AND Tzdb.IsGreaterOrSameSystemDate([EndDate], @Date) = 1)

	IF @IdRouteGroup IS NOT NULL
	BEGIN
			INSERT INTO [dbo].[RoutePointOfInterest]([IdPointOfInterest], [Comment], [RecurrenceCondition], [RecurrenceNumber],
						[AlternativeRoute], [IdRouteGroup], [Deleted], [EditedDate])
			VALUES		(@IdPointOfInterest, @Comment, 'D', 1, 1, @IdRouteGroup, 0, @Now)

			SELECT @IdRoutePointOfInterest = SCOPE_IDENTITY()

			--Insert en RouteDetail
			INSERT INTO [dbo].[RouteDetail] ([RouteDate], [IdRoutePointOfInterest], [Disabled], 
						[NoVisited], [FromHour], [ToHour], [Title], [TheoricalMinutes]) 
			VALUES		(@Date, @IdRoutePointOfInterest, 0, 0, @FromHour, @ToHour,@Title, @TheoricalMinutes) 

			SELECT @Id = SCOPE_IDENTITY()

			--Insert en DayOfWeek para mantener integridad con las rutas recurrentes y que las alternativas tengan valores en las mismas tablas.
			INSERT INTO [dbo].[RouteDayOfWeek]([IdRoutePointOfInterest],[DayOfWeek])
			VALUES		(@IdRoutePointOfInterest,@DayOfWeek)
	END
	ELSE
	BEGIN
		
			INSERT INTO [dbo].[RouteGroup]([IdPersonOfInterest] ,[StartDate] ,[EndDate] ,[Name] ,[EditedDate],[Deleted])
			VALUES  (@IdPersonOfInterest, @Date ,@Date , @RouteName , @Now,0)
	
			SELECT @IdRouteGroup = SCOPE_IDENTITY()

			INSERT INTO [dbo].[RoutePointOfInterest]([IdPointOfInterest], [Comment], [RecurrenceCondition], [RecurrenceNumber],
						[AlternativeRoute], [IdRouteGroup], [Deleted], [EditedDate])
			VALUES		(@IdPointOfInterest, @Comment, 'D', 1, 1, @IdRouteGroup, 0, @Now)

			SELECT @IdRoutePointOfInterest = SCOPE_IDENTITY()

			--Insert en RouteDetail
			INSERT INTO [dbo].[RouteDetail] ([RouteDate], [IdRoutePointOfInterest], [Disabled], 
						[NoVisited], [FromHour], [ToHour], [Title], [TheoricalMinutes]) 
			VALUES		(@Date, @IdRoutePointOfInterest, 0, 0, @FromHour, @ToHour,@Title, @TheoricalMinutes) 

			SELECT @Id = SCOPE_IDENTITY()

			--Insert en DayOfWeek para mantener integridad con las rutas recurrentes y que las alternativas tengan valores en las mismas tablas.
			INSERT INTO [dbo].[RouteDayOfWeek]([IdRoutePointOfInterest],[DayOfWeek])
			VALUES		(@IdRoutePointOfInterest,@DayOfWeek)


	END
	 
	IF Tzdb.AreSameSystemDates(@Date, (select TOP 1 M.[Date] FROM [dbo].[Mark] M WITH (NOLOCK)
		where M.[IdPersonOfInterest] = @IdPersonOfInterest AND M.[Type] = 'E' 
		order by M.[Id] desc)) = 1
        
	BEGIN
		SET @PersonAlreadyStartDay = 0
	END
	ELSE
	BEGIN
		SET @PersonAlreadyStartDay = 1
	END

	SET @DeviceId = (SELECT TOP 1 [DeviceId] FROM [dbo].[PersonOfInterest] WITH (NOLOCK) WHERE
															[Id] = @IdPersonOfInterest 
															 AND [DeviceId] IS NOT NULL)
END
