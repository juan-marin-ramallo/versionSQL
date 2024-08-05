/****** Object:  Procedure [dbo].[DisableRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 
-- Description:	SP para deshabilitar una visita de un día
-- =============================================
CREATE PROCEDURE [dbo].[DisableRoute]
(
	 @PersonAlreadyStartDay [sys].[bit] OUTPUT
	,@DeviceId [sys].[varchar](300) OUTPUT
	,@RouteDetailId [sys].[int]
)
AS
BEGIN

	UPDATE	[dbo].[RouteDetail]
	SET		[Disabled] = 1,
			[DisabledType] = 1
	WHERE	[Id] = @RouteDetailId

	DECLARE @RoutePersonOfInterest [sys].INT
	DECLARE @RouteDateSystem [sys].DATETIME

	SELECT	@RoutePersonOfInterest = RG.[IdPersonOfInterest], @RouteDateSystem = Tzdb.FromUtc(RD.[RouteDate])
	FROM	[dbo].[RouteGroup] RG WITH (NOLOCK)
			INNER JOIN [dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup] 
			INNER JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id]
	WHERE	RP.[Id] = (SELECT	RD.[IdRoutePointOfInterest] 
						FROM	[dbo].[RouteDetail] RD WITH (NOLOCK)
						WHERE	RD.[Id] = @RouteDetailId)

	IF DATEDIFF(DAY, @RouteDateSystem, (SELECT TOP 1 Tzdb.FromUtc(M.[Date]) FROM [dbo].[Mark] M WITH (NOLOCK)
											WHERE M.[IdPersonOfInterest] = @RoutePersonOfInterest AND M.[Type] = 'E'
											ORDER BY M.[Id] DESC)) = 0
        
	BEGIN
		SET @PersonAlreadyStartDay = 0
	END
	ELSE
	BEGIN
		SET @PersonAlreadyStartDay = 1
	END

	SET @DeviceId = (SELECT TOP 1 [DeviceId] 
					FROM [dbo].[PersonOfInterest] WITH (NOLOCK)
					WHERE [Id] = @RoutePersonOfInterest AND [DeviceId] IS NOT NULL)

END

-- OLD)
-- BEGIN

-- 	UPDATE	[dbo].[RouteDetail]
-- 	SET		[Disabled] = 1
-- 	WHERE	[Id] = @RouteDetailId

-- 	DECLARE @RoutePersonOfInterest [sys].INT
-- 	DECLARE @RouteDate [sys].DATETIME

-- 	SELECT	@RoutePersonOfInterest = RG.[IdPersonOfInterest], @RouteDate = RD.[RouteDate]
-- 	FROM	[dbo].[RouteGroup] RG WITH (NOLOCK)
-- 			INNER JOIN [dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup] 
-- 			INNER JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id]
-- 	WHERE	RP.[Id] = (SELECT	RD.[IdRoutePointOfInterest] 
-- 						FROM	[dbo].[RouteDetail] RD WITH (NOLOCK)
-- 						WHERE	RD.[Id] = @RouteDetailId)

-- 	IF Tzdb.AreSameSystemDates(@RouteDate, (SELECT TOP 1 M.[Date] FROM [dbo].[Mark] M WITH (NOLOCK)
-- 											WHERE M.[IdPersonOfInterest] = @RoutePersonOfInterest AND M.[Type] = 'E' 
-- 											ORDER BY M.[Id] DESC)) = 1 
        
-- 	BEGIN
-- 		SET @PersonAlreadyStartDay = 0
-- 	END
-- 	ELSE
-- 	BEGIN
-- 		SET @PersonAlreadyStartDay = 1
-- 	END

-- 	SET @DeviceId = (SELECT TOP 1 [DeviceId] 
-- 					FROM [dbo].[PersonOfInterest] WITH (NOLOCK)
-- 					WHERE [Id] = @RoutePersonOfInterest AND [DeviceId] IS NOT NULL)

-- END
