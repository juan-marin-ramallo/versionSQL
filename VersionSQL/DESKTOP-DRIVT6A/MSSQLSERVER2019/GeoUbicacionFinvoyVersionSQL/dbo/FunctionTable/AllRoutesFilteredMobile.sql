/****** Object:  TableFunction [dbo].[AllRoutesFilteredMobile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 02/04/2018
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[AllRoutesFilteredMobile]
(
	 @DateFrom [sys].[datetime]
	,@DateTo [sys].[datetime]
	,@IdPersonsOfInterest [sys].[varchar](max) = NULL
	,@IdPointsOfInterest [sys].[varchar](max) = NULL
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT		RG.Id AS RouteGroupId, RD.[Id] as IdRouteDetail, RD.[RouteDate], RD.[IdRoutePointOfInterest],
				RD.[Disabled], RP.[AlternativeRoute], RP.[Comment], RD.[FromHour], RD.[ToHour], RD.[Title],
				RP.[IdPointOfInterest], POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier,
				RG.[IdPersonOfInterest], PEI.[Identifier] AS PersonOfInterestIdentifier, 
				PEI.[Name] AS PersonOfInterestName, PEI.[LastName] AS PersonOfInterestLastName, RP.[WebAssignment],
				POI.[Latitude], POI.[Longitude], POI.[Radius]
	

	FROM		[dbo].[RouteDetail] RD WITH (NOLOCK)
				INNER JOIN	[dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[Id] = RD.[IdRoutePointOfInterest]
				INNER JOIN	[dbo].[RouteGroup] RG WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup]
				INNER JOIN	[dbo].[PointOfInterest] POI WITH (NOLOCK) ON  POI.[Id] = RP.[IdPointOfInterest]
				INNER JOIN	[dbo].[PersonOfInterest] PEI WITH (NOLOCK) ON  PEI.[Id] = RG.[IdPersonOfInterest]

	WHERE 		Tzdb.IsGreaterOrSameSystemDate(RD.[RouteDate], @DateFrom) = 1
				AND Tzdb.IsLowerOrSameSystemDate(RD.[RouteDate], @DateTo) = 1
				AND	(@IdPointsOfInterest IS NULL OR (dbo.CheckValueInList(RP.[IdPointOfInterest], @IdPointsOfInterest) = 1)) 
				AND	(@IdPersonsOfInterest IS NULL OR (dbo.CheckValueInList(RG.[IdPersonOfInterest], @IdPersonsOfInterest) = 1)) 
				--AND POI.[Deleted] = 0 AND RP.[Deleted] = 0
				--AND RG.[Deleted] = 0 
				AND RD.[Disabled] = 0

	GROUP BY	RG.Id, RD.[Id], RD.[RouteDate], RD.[IdRoutePointOfInterest],
				RD.[Disabled], RP.[AlternativeRoute], RP.[Comment], RD.[FromHour], RD.[ToHour], 
				RD.[Title], RP.[IdPointOfInterest], POI.[Name], POI.[Identifier],
				RG.[IdPersonOfInterest], PEI.[Identifier], PEI.[Name], PEI.[LastName], RP.[WebAssignment],
				POI.[Latitude], POI.[Longitude], POI.[Radius]
	
	--ORDER BY	RD.[RouteDate], RD.[Id], POI.[Identifier] , POI.[Name]

)
	
