/****** Object:  Procedure [dbo].[GetMobileCalendarDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 28/03/2018
-- Description:	SP para obtener los detalles DEL CALENDARIO (utilizado por mobile)
-- =============================================
CREATE PROCEDURE [dbo].[GetMobileCalendarDetail]
(
	 @StartDate [sys].DATETIME
	,@EndDate [sys].DATETIME
	,@IdPointsOfInterest [sys].[varchar](1000) = NULL
	,@IdPersonsOfInterest [sys].[varchar](1000) = NULL
	,@IncludeAutomaticVisits [sys].[bit] = 1
	,@IdDepartments [sys].[varchar](max) = NULL
	,@Types [sys].[varchar](max) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN

	SELECT	COALESCE (R.[IdPersonOfInterest], POIV.[IdPersonOfInterest], RNV.[PersonOfInterestId]) AS PersonOfInterestId, 
			COALESCE (R.[PersonOfInterestName], POIV.[PersonOfInterestName], RNV.[PersonOfInterestName]) AS PersonOfInterestName, 
			COALESCE (R.[PersonOfInterestLastName], POIV.[PersonOfInterestLastName], RNV.[PersonOfInterestLastName]) AS PersonOfInterestLastName,
			COALESCE (R.[PersonOfInterestIdentifier], POIV.[PersonOfInterestIdentifier], RNV.[PersonOfInterestIdentifier]) AS PersonOfInterestIdentifier, 
			COALESCE (R.[IdPointOfInterest], POIV.[IdPointOfInterest], RNV.[PointOfInterestId]) AS PointOfInterestId, 
			COALESCE (R.[PointOfInterestName], POIV.[PointOfInterestName], RNV.[PointOfInterestName]) AS PointOfInterestName,  
			COALESCE (R.[PointOfInterestIdentifier], POIV.[PointOfInterestIdentifier], RNV.[PointOfInterestIdentifier]) AS PointOfInterestIdentifier,   
			COALESCE (R.[RouteDate],POIV.[DateIn], RNV.RouteDate) AS RouteDate, R.[Title] AS RouteTitle,
			RNV.[IdRoute] AS RouteNotVisitedId,
			RNV.[NoVisitedApprovedState],
			R.[Comment] AS RouteComment,
			R.[FromHour] AS RouteFromHour,
			R.[ToHour] AS RouteToHour,
			R.[IdRouteDetail] as IdRouteDetail,
			POIV.[ElapsedTime] AS VisitTime,
			POIV.[DateIn] AS PointOfInterestVisitedInDate, 
			POIV.[DateOut] AS PointOfInterestVisitedOutDate,
			CASE 
				WHEN R.[RouteDate] IS NULL THEN 3 --Visitado no planificado
				WHEN RNV.[IdRoute] IS NOT NULL AND RNV.[NoVisitedApprovedState] != 2 THEN 4 --planificado y marcado como no visitado
				WHEN POIV.[DateIn] IS NULL AND R.[RouteDate] IS NOT NULL THEN 2 --planificado y no visitado
				WHEN POIV.[DateIn] IS NOT NULL AND R.[RouteDate] IS NOT NULL THEN 1 --visitado y planificado
				ELSE NULL
			END AS RouteStatus,
			R.[IdRouteDetail],
			R.[WebAssignment]
		
		FROM	 [dbo].PointsOfInterestWithActivityForWorkingActivity(@StartDate, @EndDate, @IdDepartments, @Types, @IdPersonsOfInterest, @IdPointsOfInterest, @IncludeAutomaticVisits, @IdUser) POIV
			
				FULL OUTER JOIN [dbo].[AllRoutesFilteredMobile](@StartDate, @EndDate, @IdPersonsOfInterest, @IdPointsOfInterest) R 
				ON (POIV.[IdPersonOfInterest] = R.[IdPersonOfInterest] AND POIV.[IdPointOfInterest] = R.[IdPointOfInterest] AND Tzdb.AreSameSystemDates(POIV.[DateIn], R.[RouteDate]) = 1)
			
				FULL OUTER JOIN RoutesMarkedNotVisitedFiltered(@StartDate, @EndDate, @IdDepartments, @Types, @IdPersonsOfInterest, @IdPointsOfInterest, @IdUser) RNV 
				ON (RNV.IdRoute = R.IdRoutePointOfInterest AND R.RouteDate = RNV.RouteDate)

		GROUP BY	COALESCE (R.[IdPersonOfInterest], POIV.[IdPersonOfInterest], RNV.[PersonOfInterestId]), 
					COALESCE (R.[PersonOfInterestName], POIV.[PersonOfInterestName], RNV.[PersonOfInterestName]) , 
					COALESCE (R.[PersonOfInterestLastName], POIV.[PersonOfInterestLastName], RNV.[PersonOfInterestLastName]) ,
					COALESCE (R.[PersonOfInterestIdentifier], POIV.[PersonOfInterestIdentifier], RNV.[PersonOfInterestIdentifier]) , 
					COALESCE (R.[IdPointOfInterest], POIV.[IdPointOfInterest], RNV.[PointOfInterestId]) , 
					COALESCE (R.[PointOfInterestName], POIV.[PointOfInterestName], RNV.[PointOfInterestName]) ,  
					COALESCE (R.[PointOfInterestIdentifier], POIV.[PointOfInterestIdentifier], RNV.[PointOfInterestIdentifier]), 
					COALESCE (R.[RouteDate],POIV.[DateIn], RNV.RouteDate), R.[Title],
					RNV.[IdRoute],
					R.[RouteDate],
					RNV.[NoVisitedApprovedState],
					R.[Comment] ,
					R.[FromHour],
					R.[ToHour],
					POIV.[ElapsedTime] ,
					POIV.[DateIn], 
					POIV.[DateOut] ,
					R.[IdRouteDetail],
					R.[WebAssignment],
					R.[IdRouteDetail] 

	--IF @OnlyConfirmedVisits = 1
	--BEGIN

	--	SELECT	*
	--	FROM	[dbo].[VisitsCalendarMobileConfirmedVisits](@StartDate, @EndDate, @IdPersonsOfInterest, 
	--											@IdPointsOfInterest, @IncludeAutomaticVisits, @OnlyConfirmedVisits)
	--	ORDER BY [RouteDate]

	--END
	--ELSE
	--BEGIN

	--	SELECT	*
	--	FROM	[dbo].[VisitsCalendarMobile](@StartDate, @EndDate, @IdPersonsOfInterest, 
	--											@IdPointsOfInterest, @IncludeAutomaticVisits, @OnlyConfirmedVisits)
	--	ORDER BY [RouteDate]

	--END
	
END
