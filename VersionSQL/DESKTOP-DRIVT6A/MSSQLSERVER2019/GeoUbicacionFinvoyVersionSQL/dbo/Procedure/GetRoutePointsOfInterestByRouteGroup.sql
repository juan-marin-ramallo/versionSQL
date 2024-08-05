/****** Object:  Procedure [dbo].[GetRoutePointsOfInterestByRouteGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 16/08/2016
-- Description:	SP para obtener LOS PUNTOS DE LA RUTA JUNTO A SU FRECUENCIA Y RECURRENCIA.
-- Change: Matias Corso - 31/10/2016: No aplico filtro de días para rutas con frecuencia diaria
-- =============================================
CREATE PROCEDURE [dbo].[GetRoutePointsOfInterestByRouteGroup]
(
	 @IdRouteGroup [sys].[int]
	,@DaysOfWeek [sys].[varchar](1000) = NULL
	,@RecurrenceConditions [sys].[varchar](1000) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN

	SELECT	RP.[Id], RP.[IdPointOfInterest], RP.[RecurrenceCondition], RP.[RecurrenceNumber],
			RP.[AlternativeRoute], POI.[Identifier] AS PointOfInterestIdentifier,
			POI.[Name] AS PointOfInterestName, RDW.[DayOfWeek], RP.[Comment], RD.[RouteDate] AS AlternativeRouteDate

	FROM	[dbo].[RoutePointOfInterest] RP WITH (NOLOCK)
			INNER JOIN dbo.[RouteDayOfWeek] RDW WITH (NOLOCK) ON RP.[Id] = RDW.[IdRoutePointOfInterest]
			INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON RP.[IdPointOfInterest] = POI.[Id]
			LEFT JOIN [dbo].[RouteDetail] RD WITH (NOLOCK) ON RD.[IdRoutePointOfInterest] = RP.[Id] AND RP.[AlternativeRoute] = 1
	
	WHERE 	RP.[IdRouteGroup] = @IdRouteGroup AND			
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(RP.[IdPointOfInterest], @IdPointsOfInterest) = 1)) AND
			((@DaysOfWeek IS NULL) OR (RP.RecurrenceCondition = 'D' AND RP.AlternativeRoute = 0) OR (dbo.CheckRouteDaysOfWeek(RP.[Id], @DaysOfWeek) = 1)) AND
			((@RecurrenceConditions IS NULL) OR (dbo.CheckCharValueInList(RP.[RecurrenceCondition], @RecurrenceConditions) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND
			POI.[Deleted] = 0 AND RP.[Deleted] = 0

	ORDER BY RP.[AlternativeRoute]
END
