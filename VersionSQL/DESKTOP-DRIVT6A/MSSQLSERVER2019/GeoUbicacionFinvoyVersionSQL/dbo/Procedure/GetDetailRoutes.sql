/****** Object:  Procedure [dbo].[GetDetailRoutes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 20/03/2018
-- Description:	SP para obtener los detalles de las rutas por día (utilizando por mobile)
-- =============================================
CREATE PROCEDURE [dbo].[GetDetailRoutes]
(
	 @StartDate [sys].[datetime]
	,@EndDate [sys].[datetime]
	,@IdPointsOfInterest [sys].[varchar](1000) = NULL
	,@IdPersonsOfInterest [sys].[varchar](1000) = NULL
	,@AlternativeRoute [sys].[BIT] = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN

	SELECT		RG.Id AS RouteGroupId, RD.[Id], RD.[RouteDate], RD.[IdRoutePointOfInterest],
				RD.[Disabled], RP.[AlternativeRoute], RP.[Comment], RD.[FromHour], RD.[ToHour], RD.[Title],
				RP.[IdPointOfInterest], POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier,
				RG.[IdPersonOfInterest], PEI.[Identifier] AS PersonOfInterestIdentifier, 
				PEI.[Name] AS PersonOfInterestName, PEI.[LastName] AS PersonOfInterestLastName, 
				Z.[Id] as IdZone, Z.[Description] as ZoneName, RP.[WebAssignment]
	
	FROM		[dbo].[RouteDetail] RD WITH (NOLOCK)
				INNER JOIN	[dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[Id] = RD.[IdRoutePointOfInterest]
				INNER JOIN	[dbo].[RouteGroup] RG WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup]
				INNER JOIN	[dbo].[PointOfInterest] POI WITH (NOLOCK) ON  POI.[Id] = RP.[IdPointOfInterest]
				INNER JOIN	[dbo].[PersonOfInterest] PEI WITH (NOLOCK) ON  PEI.[Id] = RG.[IdPersonOfInterest]
				LEFT JOIN	[dbo].[PersonOfInterestZone] PIZ WITH (NOLOCK) ON  PIZ.[IdPersonOfInterest] = PEI.[Id]
				LEFT JOIN	[dbo].[ZoneTranslated] Z WITH (NOLOCK) ON  Z.[Id] = PIZ.[IdZone] AND Z.[ApplyToAllPersonOfInterest] = 0

	WHERE 		Tzdb.IsLowerOrSameSystemDate(RD.[RouteDate], @EndDate) = 1
				AND Tzdb.IsGreaterOrSameSystemDate(RD.[RouteDate], @StartDate) = 1
				AND	(@IdPointsOfInterest IS NULL OR (dbo.CheckValueInList(RP.[IdPointOfInterest], @IdPointsOfInterest) = 1)) 
				AND	(@IdPersonsOfInterest IS NULL OR (dbo.CheckValueInList(RG.[IdPersonOfInterest], @IdPersonsOfInterest) = 1)) 
				AND	((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) 
				AND	((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))
				AND (@AlternativeRoute IS NULL OR RP.[AlternativeRoute] = @AlternativeRoute)
				AND POI.[Deleted] = 0 AND RP.[Deleted] = 0
				AND RG.[Deleted] = 0 AND RD.[Disabled] = 0

	GROUP BY	RG.Id, RD.[Id], RD.[RouteDate], RD.[IdRoutePointOfInterest],
				RD.[Disabled], RP.[AlternativeRoute], RP.[Comment], RD.[FromHour], RD.[ToHour], 
				RD.[Title], RP.[IdPointOfInterest], POI.[Name], POI.[Identifier],
				RG.[IdPersonOfInterest], PEI.[Identifier], PEI.[Name], PEI.[LastName],
				Z.[Id], Z.[Description], RP.[WebAssignment]
	
	ORDER BY	RD.[RouteDate], RD.[Id], POI.[Identifier] , POI.[Name]
	
END
