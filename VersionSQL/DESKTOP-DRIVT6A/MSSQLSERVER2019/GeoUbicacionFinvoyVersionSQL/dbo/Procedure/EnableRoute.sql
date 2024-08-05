/****** Object:  Procedure [dbo].[EnableRoute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 17/08/2016
-- Description:	SP para volver a habilitar RUTA del día
-- =============================================
CREATE PROCEDURE [dbo].[EnableRoute]
(
	 @PersonAlreadyStartDay [sys].[bit] OUTPUT
	,@DeviceId [sys].[varchar](300) OUTPUT
	,@RouteDetailId [sys].[int]
)
AS
BEGIN
	DECLARE @RoutePersonOfInterest [sys].[int]
	DECLARE @RouteDate [sys].[datetime]

	SELECT  @RoutePersonOfInterest = RG.[IdPersonOfInterest], @RouteDate = RD.[RouteDate]
	FROM	  [dbo].[RouteGroup] RG WITH (NOLOCK)
			    INNER JOIN [dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup] 
			    INNER JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id]
	WHERE   RD.[Id] = @RouteDetailId
	
--	WHERE	RP.[Id] = (SELECT	RD.[IdRoutePointOfInterest] 
--						FROM	[dbo].[RouteDetail] RD WITH (NOLOCK)
--						WHERE	RD.[Id] = @RouteDetailId)

	DECLARE @ExistsPersonOfInterestAbsence [sys].[bit]
	SET @ExistsPersonOfInterestAbsence = CASE WHEN (SELECT  TOP(1) [Id]
													FROM    [dbo].[PersonOfInterestAbsence] WITH (NOLOCK)
													WHERE   [IdPersonOfInterest] = @RoutePersonOfInterest
															AND @RouteDate >= [FromDate] AND ([ToDate] IS NULL OR @RouteDate < [ToDate])) IS NULL
											THEN 0
											ELSE 1
										END

	UPDATE	[dbo].[RouteDetail]
	SET		[Disabled] = CASE WHEN @ExistsPersonOfInterestAbsence = 0 THEN 0 ELSE 1 END,
			[DisabledType] = CASE WHEN @ExistsPersonOfInterestAbsence = 0 THEN NULL ELSE 2 END -- Person of Interest disabled
	WHERE	[Id] = @RouteDetailId

	IF DATEDIFF(DAY, Tzdb.FromUtc(@RouteDate), (select TOP 1 Tzdb.FromUtc(M.[Date]) FROM [dbo].[Mark] M WITH (NOLOCK)
											where M.[IdPersonOfInterest] = @RoutePersonOfInterest AND M.[Type] = 'E' 
											order by M.[Id] desc)) = 0 
        
	BEGIN
		SET @PersonAlreadyStartDay = 0
	END
	ELSE
	BEGIN
		SET @PersonAlreadyStartDay = 1
	END

	SET @DeviceId = (SELECT TOP 1 [DeviceId] 
					FROM	[dbo].[PersonOfInterest] WITH (NOLOCK)
					WHERE	[Id] = @RoutePersonOfInterest AND [DeviceId] IS NOT NULL)
	
END

-- OLD)
-- BEGIN
	
-- 	UPDATE	[dbo].[RouteDetail]
-- 	SET		[Disabled] = 0
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

-- 	IF Tzdb.AreSameSystemDates(@RouteDate, (select TOP 1 M.[Date] FROM [dbo].[Mark] M WITH (NOLOCK)
-- 											where M.[IdPersonOfInterest] = @RoutePersonOfInterest AND M.[Type] = 'E' 
-- 											order by M.[Id] desc)) = 1 
        
-- 	BEGIN
-- 		SET @PersonAlreadyStartDay = 0
-- 	END
-- 	ELSE
-- 	BEGIN
-- 		SET @PersonAlreadyStartDay = 1
-- 	END

-- 	SET @DeviceId = (SELECT TOP 1 [DeviceId] 
-- 					FROM	[dbo].[PersonOfInterest] WITH (NOLOCK)
-- 					WHERE	[Id] = @RoutePersonOfInterest AND [DeviceId] IS NOT NULL)
	
-- END
