/****** Object:  Procedure [dbo].[GetPlannedRoutePointsOfInterestByRouteGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 17/08/2016
-- Description:	SP para obtener LOS PUNTOS DE LA RUTA planificada JUNTO A SU FRECUENCIA Y RECURRENCIA.
-- =============================================
CREATE PROCEDURE [dbo].[GetPlannedRoutePointsOfInterestByRouteGroup]
(
	 @IdRouteGroup [sys].[int]
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@DaysOfWeek [sys].[varchar](1000) = NULL
	,@IdUser [sys].[int] = NULL
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
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(RP.[IdPointOfInterest], @IdPointsOfInterest) = 1)) AND
			((@DaysOfWeek IS NULL) OR (RP.RecurrenceCondition = 'D' AND RP.AlternativeRoute = 0) OR (dbo.CheckRouteDaysOfWeek(RP.[Id], @DaysOfWeek) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND
			POI.[Deleted] = 0 AND RP.[Deleted] = 0 AND RP.[AlternativeRoute] = 0 AND
			RD.[Id] = (SELECT TOP 1 Id FROM [dbo].[RouteDetail] WITH (NOLOCK) where [IdRoutePointOfInterest] = RP.[Id])

	ORDER BY RP.[Id]
END
