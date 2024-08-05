/****** Object:  Procedure [dbo].[SaveAlternativeRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 19/08/2016
-- Description:	SP para guardar una ruta ALTERNATIVA
-- =============================================
CREATE PROCEDURE [dbo].[SaveAlternativeRoute]
(
	 @Id [sys].[int] = 0 OUTPUT
    ,@PersonAlreadyStartDay [sys].[bit] OUTPUT
	,@DeviceId [sys].[varchar](300) OUTPUT
	,@Date [sys].DATETIME
	,@DayOfWeek [sys].[INT]
	,@IdPointOfInterest [sys].[INT]
    ,@IdRouteGroup[sys].[INT]
    ,@Comment [sys].[VARCHAR](230) = NULL
	,@FromHour [sys].[time](7) = NULL
	,@ToHour [sys].[time](7) = NULL
	,@Title [sys].[VARCHAR](250) = NULL
	,@TheoricalMinutes [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @IdPersonOfInterest [sys].[INT] = 0
	DECLARE @IdRoutePointOfInterest [sys].[INT] = 0

	SET @IdPersonOfInterest = (SELECT [IdPersonOfInterest] FROM [dbo].[RouteGroup] WITH (NOLOCK) WHERE [Id] = @IdRouteGroup)

	--Insert en RoutePointOfInterest con el RouteGroup como ruta padre.
	INSERT INTO [dbo].[RoutePointOfInterest]([IdPointOfInterest], [Comment], 
				[RecurrenceCondition], [RecurrenceNumber],[AlternativeRoute], 
				[IdRouteGroup], [Deleted], [EditedDate])
	VALUES		(@IdPointOfInterest, @Comment, 'D', 1, 1, @IdRouteGroup, 0, GETUTCDATE())
				

	SELECT @IdRoutePointOfInterest = SCOPE_IDENTITY()

	--Insert en RouteDetail
	INSERT INTO [dbo].[RouteDetail] ([RouteDate], [IdRoutePointOfInterest], [Disabled], [NoVisited], 
				[FromHour], [ToHour], [Title], [TheoricalMinutes]) 
	VALUES		(@Date, @IdRoutePointOfInterest, 0, 0, @FromHour, @ToHour, @Title, @TheoricalMinutes) 

	--Insert en DayOfWeek para mantener integridad con las rutas recurrentes y que las alternativas tengan valores en las mismas tablas.
	INSERT INTO [dbo].[RouteDayOfWeek]([IdRoutePointOfInterest],[DayOfWeek])
	VALUES		(@IdRoutePointOfInterest,@DayOfWeek)

	SELECT @Id = SCOPE_IDENTITY()

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
