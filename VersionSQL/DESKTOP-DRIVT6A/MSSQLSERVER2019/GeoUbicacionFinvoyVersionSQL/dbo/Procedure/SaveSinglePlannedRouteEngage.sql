/****** Object:  Procedure [dbo].[SaveSinglePlannedRouteEngage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
CREATE PROCEDURE [dbo].[SaveSinglePlannedRouteEngage]
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
)
AS
BEGIN

	IF NOT EXISTS (SELECT 1 FROM [dbo].[RouteDetail] RDW
				INNER JOIN dbo.[RoutePointOfInterest] RP ON RP.[Id] = RDW.[IdRoutePointOfInterest]
				INNER JOIN dbo.[RouteGroup] RG ON RP.[IdRouteGroup] = RG.[Id]
				where Tzdb.AreSameSystemDates(RDW.[RouteDate], GETUTCDATE()) = 1 AND RG.[IdPersonOfInterest] = @IdPersonOfInterest
				AND RP.[IdPointOfInterest] = @IdPointOfInterest AND RP.[Deleted] = 0 and RDW.[Disabled] = 0)
	BEGIN
		DECLARE @IdRoutePointOfInterest [sys].[INT]
		DECLARE @IdRouteGroup [sys].[INT] = 0

		IF EXISTS (SELECT 1 FROM [dbo].[RouteGroup] WHERE [IdPersonOfInterest] = @IdPersonOfInterest AND [Deleted] = 0
					AND Tzdb.IsLowerOrSameSystemDate([StartDate], @Date) = 1 AND Tzdb.IsGreaterOrSameSystemDate([EndDate], @Date) = 1)
		BEGIN
				SET @IdRouteGroup = (SELECT TOP 1 [Id] FROM [dbo].[RouteGroup] WHERE [IdPersonOfInterest] = @IdPersonOfInterest AND [Deleted] = 0
					AND Tzdb.IsLowerOrSameSystemDate([StartDate], @Date) = 1 AND Tzdb.IsGreaterOrSameSystemDate([EndDate], @Date) = 1)

				INSERT INTO [dbo].[RoutePointOfInterest]([IdPointOfInterest], [Comment], [RecurrenceCondition], [RecurrenceNumber],
							[AlternativeRoute], [IdRouteGroup], [Deleted], [EditedDate])
				VALUES		(@IdPointOfInterest, @Comment, 'D', 1, 1, @IdRouteGroup, 0, GETUTCDATE())

				SELECT @IdRoutePointOfInterest = SCOPE_IDENTITY()

				--Insert en RouteDetail
				INSERT INTO [dbo].[RouteDetail] ([RouteDate], [IdRoutePointOfInterest], [Disabled], [NoVisited]) 
				VALUES		(@Date, @IdRoutePointOfInterest, 0, 0) 

				SELECT @Id = SCOPE_IDENTITY()

				--Insert en DayOfWeek para mantener integridad con las rutas recurrentes y que las alternativas tengan valores en las mismas tablas.
				INSERT INTO [dbo].[RouteDayOfWeek]([IdRoutePointOfInterest],[DayOfWeek])
				VALUES		(@IdRoutePointOfInterest,@DayOfWeek)
		END
		ELSE
		BEGIN
		
				INSERT INTO [dbo].[RouteGroup]([IdPersonOfInterest] ,[StartDate] ,[EndDate] ,[Name] ,[EditedDate],[Deleted])
				VALUES  (@IdPersonOfInterest, @Date, @Date, @RouteName, GETUTCDATE(), 0)
	
				SELECT @IdRouteGroup = SCOPE_IDENTITY()

				INSERT INTO [dbo].[RoutePointOfInterest]([IdPointOfInterest], [Comment], [RecurrenceCondition], [RecurrenceNumber],
							[AlternativeRoute], [IdRouteGroup], [Deleted], [EditedDate])
				VALUES		(@IdPointOfInterest, @Comment, 'D', 1, 1, @IdRouteGroup, 0, GETUTCDATE())

				SELECT @IdRoutePointOfInterest = SCOPE_IDENTITY()

				--Insert en RouteDetail
				INSERT INTO [dbo].[RouteDetail] ([RouteDate], [IdRoutePointOfInterest], [Disabled], [NoVisited]) 
				VALUES		(@Date, @IdRoutePointOfInterest, 0, 0) 

				SELECT @Id = SCOPE_IDENTITY()

				--Insert en DayOfWeek para mantener integridad con las rutas recurrentes y que las alternativas tengan valores en las mismas tablas.
				INSERT INTO [dbo].[RouteDayOfWeek]([IdRoutePointOfInterest],[DayOfWeek])
				VALUES		(@IdRoutePointOfInterest,@DayOfWeek)


		END
	 
	END
	ELSE
	BEGIN

		SET @Id = 0

	END

	IF Tzdb.AreSameSystemDates(@Date, (select TOP 1 M.[Date] FROM [dbo].[Mark] M
			where M.[IdPersonOfInterest] = @IdPersonOfInterest AND M.[Type] = 'E' 
			order by M.[Id] desc)) = 1 
        
		BEGIN
			SET @PersonAlreadyStartDay = 0
		END
		ELSE
		BEGIN
			SET @PersonAlreadyStartDay = 1
		END

		SET @DeviceId = (SELECT TOP 1 [DeviceId] FROM [dbo].[PersonOfInterest]  WHERE
																[Id] = @IdPersonOfInterest 
																 AND [DeviceId] IS NOT NULL)
END
