/****** Object:  Procedure [dbo].[GetDetailRoutesGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 18/08/2016
-- Description:	SP para obtener las rutas DETALLADAS que están activas al momento
-- =============================================
CREATE PROCEDURE [dbo].[GetDetailRoutesGroup]
(
	 @IdRoutesGroup [sys].[varchar](max) = NULL
	,@StartDate [sys].[datetime]
	,@EndDate [sys].[datetime]
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN

	DECLARE @IdRoutesGroupLocal [sys].[varchar](max) 
	DECLARE @StartDateLocal [sys].[datetime]
	DECLARE @EndDateLocal [sys].[datetime]
	DECLARE @IdPersonsOfInterestLocal [sys].[varchar](max)
	DECLARE @IdPointsOfInterestLocal [sys].[varchar](max)
	DECLARE @IdUserLocal [sys].[int] 

	SET @IdRoutesGroupLocal = @IdRoutesGroup
	SET @StartDateLocal = @StartDate
	SET @EndDateLocal = @EndDate
	SET @IdPersonsOfInterestLocal = @IdPersonsOfInterest
	SET @IdPointsOfInterestLocal = @IdPointsOfInterest
	SET @IdUserLocal = @IdUser

	SELECT		RG.[Id], RG.[IdPersonOfInterest], RG.[Name], RG.[StartDate], RG.[EndDate], RG.[EditedDate],
				P.[Name] AS PersonOfInterestName, P.[LastName] AS PersonOfInterestLastName, P.[Status] AS PersonOfInterestStatus

	FROM		[dbo].[RouteGroup] RG
				INNER JOIN dbo.[RoutePointOfInterest] RP ON RG.[Id] = RP.[IdRouteGroup]
				INNER JOIN dbo.[RouteDetail] RD ON RP.[Id] = RD.[IdRoutePointOfInterest]
				INNER JOIN [dbo].[PersonOfInterest] P ON RG.[IdPersonOfInterest] = P.[Id]
				INNER JOIN [dbo].[PointOfInterest] POI ON RP.[IdPointOfInterest] = POI.[Id]
	
	WHERE 		(CAST(RD.[RouteDate] AS [sys].[date]) <= CAST(@EndDateLocal AS [sys].[date])) AND
				(CAST(RD.[RouteDate] AS [sys].[date]) >= CAST(@StartDateLocal AS [sys].[date])) AND
				((@IdRoutesGroupLocal IS NULL) OR (dbo.CheckValueInList(RG.[Id], @IdRoutesGroupLocal) = 1)) AND
				((@IdPersonsOfInterestLocal IS NULL) OR (dbo.CheckValueInList(RG.[IdPersonOfInterest], @IdPersonsOfInterestLocal) = 1)) AND
				((@IdPointsOfInterestLocal IS NULL) OR (dbo.CheckValueInList(RP.[IdPointOfInterest], @IdPointsOfInterestLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserLocal) = 1)) AND
				((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUserLocal) = 1)) AND
				RG.[Deleted] = 0 AND (RP.[Deleted] = 0 OR RP.[AlternativeRoute] = 1) 
				AND P.[Deleted] = 0 AND POI.[Deleted] = 0

	GROUP BY	RG.[Id], RG.[IdPersonOfInterest], RG.[StartDate], RG.[EndDate], RG.[EditedDate],
				P.[Name], P.[LastName], P.[Status], RG.[Name]
	
	ORDER BY	RG.[StartDate]
END
