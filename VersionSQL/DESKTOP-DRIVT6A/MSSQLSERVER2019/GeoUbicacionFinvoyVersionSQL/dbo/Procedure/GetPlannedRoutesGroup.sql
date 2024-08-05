/****** Object:  Procedure [dbo].[GetPlannedRoutesGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 16/08/2016
-- Description:	SP para obtener las rutas planificadas que están activas al momento
-- Change: Matias Corso - 01/11/2016: No aplico filtro de días para rutas con frecuencia diaria
-- =============================================
CREATE PROCEDURE [dbo].[GetPlannedRoutesGroup]
(
	 @IdRoutesGroup [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@DaysOfWeek [sys].[varchar](1000) = NULL
	,@IdUser [sys].[int] = NULL
	,@IncludeDueRoutes [sys].[bit] = NULL
)
AS
BEGIN
	DECLARE @IdRoutesGroupLocal [sys].[varchar](max)
	DECLARE @IdPersonsOfInterestLocal [sys].[varchar](max)
	DECLARE @IdPointsOfInterestLocal [sys].[varchar](max)
	DECLARE @DaysOfWeekLocal [sys].[varchar](1000)
	DECLARE @IdUserLocal [sys].[int]
	DECLARE @IncludeDueRoutesLocal [sys].[bit]

	SET @IdRoutesGroupLocal = @IdRoutesGroup
	SET @IdPersonsOfInterestLocal = @IdPersonsOfInterest
	SET @IdPointsOfInterestLocal = @IdPointsOfInterest
	SET @DaysOfWeekLocal = @DaysOfWeek
	SET @IdUserLocal = @IdUser
	SET @IncludeDueRoutesLocal = @IncludeDueRoutes

	SELECT		RG.[Id], RG.[IdPersonOfInterest], RG.[Name], RG.[StartDate], RG.[EndDate], RG.[EditedDate],
				P.[Name] AS PersonOfInterestName, P.[LastName] AS PersonOfInterestLastName

	FROM		[dbo].[RouteGroup] RG WITH (NOLOCK)
				INNER JOIN dbo.[RoutePointOfInterest] RP WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup]
				--INNER JOIN dbo.[RouteDayOfWeek] RDW WITH (NOLOCK) ON RP.[Id] = RDW.[IdRoutePointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK) ON RG.[IdPersonOfInterest] = P.[Id]
				INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON RP.[IdPointOfInterest] = POI.[Id]
	
	WHERE 		((@IncludeDueRoutesLocal = 1) OR (Tzdb.IsGreaterOrSameSystemDate(RG.[EndDate], GETUTCDATE()) = 1))  AND -- PARA MOSTRAR SOLO RUTAS ACTIVAS
				((@IdRoutesGroupLocal IS NULL) OR (dbo.CheckValueInList(RG.[Id], @IdRoutesGroupLocal) = 1)) AND
				((@IdPersonsOfInterestLocal IS NULL) OR (dbo.CheckValueInList(RG.[IdPersonOfInterest], @IdPersonsOfInterestLocal) = 1)) AND
				((@IdPointsOfInterestLocal IS NULL) OR (dbo.CheckValueInList(RP.[IdPointOfInterest], @IdPointsOfInterestLocal) = 1)) AND
				((@DaysOfWeekLocal IS NULL) OR (RP.RecurrenceCondition = 'D' AND RP.AlternativeRoute = 0) OR (dbo.CheckRouteDaysOfWeek(RP.[Id], @DaysOfWeekLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUserLocal) = 1)) AND
				RG.[Deleted] = 0 AND RP.[Deleted] = 0 AND P.[Deleted] = 0 AND POI.[Deleted] = 0
				AND RP.[AlternativeRoute] = 0

	GROUP BY	RG.[Id], RG.[IdPersonOfInterest], RG.[StartDate], RG.[EndDate], RG.[EditedDate],
				P.[Name], P.[LastName], RG.[Name]
	
	ORDER BY	RG.[StartDate]
END
