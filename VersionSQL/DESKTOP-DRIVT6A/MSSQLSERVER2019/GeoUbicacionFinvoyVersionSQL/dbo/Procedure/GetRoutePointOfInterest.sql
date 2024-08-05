/****** Object:  Procedure [dbo].[GetRoutePointOfInterest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 24/08/2016
-- Description:	SP para obtener LOS PUNTOS DE LA RUTA padre JUNTO A SU FRECUENCIA Y RECURRENCIA.
-- =============================================
CREATE PROCEDURE [dbo].[GetRoutePointOfInterest]
(
	 @IdRouteGroup [sys].[int]
)
AS
BEGIN

	SELECT	RP.[Id], RP.[IdPointOfInterest], RP.[RecurrenceCondition], RP.[RecurrenceNumber], 
			POI.[Identifier] AS PointOfInterestIdentifier, POI.[Name] AS PointOfInterestName, 
			RDW.[DayOfWeek], RP.[Comment], RD.[FromHour], RD.[ToHour], RD.[TheoricalMinutes]

	FROM	[dbo].[RoutePointOfInterest] RP WITH (NOLOCK)
			INNER JOIN dbo.[RouteDayOfWeek] RDW WITH (NOLOCK) ON RP.[Id] = RDW.[IdRoutePointOfInterest]
			INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON RP.[IdPointOfInterest] = POI.[Id]
			LEFT JOIN  [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id]
	
	WHERE 	RP.[IdRouteGroup] = @IdRouteGroup AND
			POI.[Deleted] = 0 AND RP.[Deleted] = 0 AND RP.[AlternativeRoute] = 0
			AND RD.[Id] = (SELECT TOP 1 Id FROM [dbo].[RouteDetail] WITH (NOLOCK) WHERE [IdRoutePointOfInterest] = RP.[Id])

	ORDER BY RP.[Id]
END
