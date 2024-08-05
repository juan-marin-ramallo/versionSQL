/****** Object:  Procedure [dbo].[GetPersonRoutesApi]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 05/02/2021
-- Description:	SP para obtener la info general de las rutas (incluyendo puntos) de una persona de interes para usar en la api
-- =============================================
CREATE PROCEDURE [dbo].[GetPersonRoutesApi]
(
	 @IdPersonOfInterest [sys].int
)
AS
BEGIN

	SELECT		RG.[Id], RG.[IdPersonOfInterest], RG.[Name], RG.[StartDate], RG.[EndDate], RG.[EditedDate],
				P.[Name] AS PersonOfInterestName, P.[LastName] AS PersonOfInterestLastName, RP.[IdPointOfInterest]

	FROM		[dbo].[RouteGroup] RG WITH (NOLOCK)
				INNER JOIN dbo.[RoutePointOfInterest] RP WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup]
				INNER JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK) ON RG.[IdPersonOfInterest] = P.[Id]
				INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON RP.[IdPointOfInterest] = POI.[Id]
	
	WHERE 		RG.[IdPersonOfInterest] = @IdPersonOfInterest AND
				RG.[Deleted] = 0 AND RP.[Deleted] = 0 AND P.[Deleted] = 0 AND POI.[Deleted] = 0

	GROUP BY	RG.[Id], RG.[IdPersonOfInterest], RG.[StartDate], RG.[EndDate], RG.[EditedDate],
				P.[Name], P.[LastName], RG.[Name], RP.[IdPointOfInterest]
	
	ORDER BY	RG.[Id]
END
