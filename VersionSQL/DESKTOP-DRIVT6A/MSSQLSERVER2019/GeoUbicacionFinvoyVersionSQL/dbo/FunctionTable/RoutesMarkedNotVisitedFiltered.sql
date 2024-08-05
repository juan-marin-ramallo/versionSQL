/****** Object:  TableFunction [dbo].[RoutesMarkedNotVisitedFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 23/08/2016
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[RoutesMarkedNotVisitedFiltered]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL	
	,@IdUser [sys].[int] = NULL
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT	RP.[Id] as IdRoute, RD.[Id] as IdRouteDetail, RD.RouteDate, 
			S.[Id] AS PersonOfInterestId, S.[Name] AS PersonOfInterestName, 
			S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier,
			[IdPointOfInterest] AS PointOfInterestId, P.[Name] AS PointOfInterestName, 
			P.[Identifier] AS PointOfInterestIdentifier, RNO.[Description], RD.[NoVisitedApprovedState],
			RD.[NoVisitedApprovedDate], RD.[NoVisitedApprovedComment], RD.[IdUserNoVisitedApproved],
			U.[Name] as [NoVisitedApprovedUserName], U.[LastName] as [NoVisitedApprovedUserLastName], RD.[DateNoVisited]

	FROM	[dbo].[RouteDetail] RD with(nolock)
			INNER JOIN dbo.[RoutePointOfInterest] RP with(nolock) ON RP.[Id] = RD.[IdRoutePointOfInterest]
			INNER JOIN dbo.[RouteGroup] RG with(nolock) ON RG.[Id] = RP.[IdRouteGroup]
			INNER JOIN [dbo].[PointOfInterest] P with(nolock) ON P.[Id] = RP.[IdPointOfInterest]
			LEFT OUTER JOIN [dbo].[PersonOfInterest] S with(nolock) ON S.[Id] = RG.[IdPersonOfInterest]
			LEFT JOIN [dbo].[RouteNoVisitOption] RNO with(nolock) ON RNO.[Id] = RD.[IdRouteNoVisitOption]
			LEFT OUTER JOIN [dbo].[User] U with(nolock) on RD.[IdUserNoVisitedApproved] = U.[Id]

	WHERE	(Tzdb.IsGreaterOrSameSystemDate(RD.[RouteDate], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate(RD.[RouteDate], @DateTo) = 1) AND
			((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND
			((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND
			((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND
			((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND			
			((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
			((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))	 
			AND RD.[NoVisited] = 1
			AND RD.[Disabled] = 0

	GROUP BY RP.[Id], RD.[Id], S.[Id], S.[Name], S.[LastName], S.[Identifier], RD.RouteDate, 
			[IdPointOfInterest], P.[Name], P.[Latitude], P.[Longitude], P.[Identifier], RNO.[Description], RD.[NoVisitedApprovedState], RD.[NoVisitedApprovedComment],
			RD.[NoVisitedApprovedDate], RD.[IdUserNoVisitedApproved], U.[Name], U.[LastName], RD.[DateNoVisited]

)
