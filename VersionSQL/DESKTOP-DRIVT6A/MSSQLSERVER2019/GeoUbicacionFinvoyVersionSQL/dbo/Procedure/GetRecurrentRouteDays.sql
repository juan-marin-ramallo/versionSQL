/****** Object:  Procedure [dbo].[GetRecurrentRouteDays]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 29/06/2015
-- Description:	SP para obtener los dias de la semana de determinada ruta
-- =============================================
CREATE PROCEDURE [dbo].[GetRecurrentRouteDays]
(
	@IdRoute [sys].[int]
)
AS
BEGIN
	SELECT		RD.[DayOfWeek]
	FROM		[dbo].[RoutePointOfInterest] RP WITH (NOLOCK)
				INNER JOIN [dbo].[RouteDayOfWeek] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id]
	WHERE		RD.[IdRoutePointOfInterest] = @IdRoute
END
