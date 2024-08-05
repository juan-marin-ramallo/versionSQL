/****** Object:  Procedure [dbo].[GetRoutesGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 16/08/2016
-- Description:	SP para obtener las rutas jerarquia 1 que están activas al momento
-- Change: Matias Corso - 31/10/2016: No aplico filtro de días para rutas con frecuencia diaria
-- =============================================
CREATE PROCEDURE [dbo].[GetRoutesGroup]
(
	 @IdRoutesGroup [sys].[varchar](max) = NULL
	,@DaysOfWeek [sys].[varchar](1000) = NULL
	,@RecurrenceConditions [sys].[varchar](1000) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN

	SELECT		RG.[Id], RG.[IdPersonOfInterest], RG.[Name], RG.[StartDate], RG.[EndDate], RG.[EditedDate],
				P.[Name] AS PersonOfInterestName, P.[LastName] AS PersonOfInterestLastName

	FROM		[dbo].[RouteGroup] RG WITH (NOLOCK)
				INNER JOIN dbo.[RoutePointOfInterest] RP WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup]
				--INNER JOIN dbo.[RouteDayOfWeek] RDW WITH (NOLOCK) ON RP.[Id] = RDW.[IdRoutePointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK) ON RG.[IdPersonOfInterest] = P.[Id]
				INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON RP.[IdPointOfInterest] = POI.[Id]
	
	WHERE 		Tzdb.IsGreaterOrSameSystemDate(RG.[EndDate], GETUTCDATE()) = 1 AND -- PARA MOSTRAR SOLO RUTAS ACTIVAS
				((@IdRoutesGroup IS NULL) OR (dbo.CheckValueInList(RG.[Id], @IdRoutesGroup) = 1)) AND
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(RG.[IdPersonOfInterest], @IdPersonsOfInterest) = 1)) AND
				((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(RP.[IdPointOfInterest], @IdPointsOfInterest) = 1)) AND
				((@DaysOfWeek IS NULL) OR (RP.RecurrenceCondition = 'D' AND RP.AlternativeRoute = 0) OR (dbo.CheckRouteDaysOfWeek(RP.[Id], @DaysOfWeek) = 1)) AND
				((@RecurrenceConditions IS NULL) OR (dbo.CheckCharValueInList(RP.[RecurrenceCondition], @RecurrenceConditions) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1)) AND
				RG.[Deleted] = 0 AND RP.[Deleted] = 0 AND P.[Deleted] = 0 AND POI.[Deleted] = 0

	GROUP BY	RG.[Id], RG.[IdPersonOfInterest], RG.[StartDate], RG.[EndDate], RG.[EditedDate],
				P.[Name], P.[LastName], RG.[Name]
	
	ORDER BY	RG.[StartDate]
END
