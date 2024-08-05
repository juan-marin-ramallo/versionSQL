/****** Object:  Procedure [dbo].[GetRouteById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 11/11/2015
-- Description:	SP para obtener una ruta segun su id
-- =============================================
CREATE PROCEDURE [dbo].[GetRouteById]
(
	@IdRoutePointOfInterest [sys].[int] = NULL
)
AS
BEGIN

	SELECT	RP.[Id],RG.[IdPersonOfInterest], RP.[IdPointOfInterest], RG.[StartDate], RG.[EndDate],
			RP.[RecurrenceCondition], RP.[RecurrenceNumber], RP.[AlternativeRoute], RP.[EditedDate], RP.[Comment],
			P.[Name] AS PersonOfInterestName, P.[LastName] AS PersonOfInterestLastName, POI.[Identifier] AS PointOfInterestIdentifier,
			POI.[Name] AS PointOfInterestName, RDW.[DayOfWeek]

	FROM	[dbo].[RoutePointOfInterest] RP WITH (NOLOCK)
			INNER JOIN [dbo].[RouteGroup] RG WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup]
			INNER JOIN [dbo].[RouteDayOfWeek] RDW WITH (NOLOCK) ON RP.[Id] = RDW.[IdRoutePointOfInterest]
			INNER JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK) ON RG.[IdPersonOfInterest] = P.[Id]
			INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON RP.[IdPointOfInterest] = POI.[Id]
	
	WHERE	RP.[Id] = @IdRoutePointOfInterest

	ORDER BY RP.[Id]
END
