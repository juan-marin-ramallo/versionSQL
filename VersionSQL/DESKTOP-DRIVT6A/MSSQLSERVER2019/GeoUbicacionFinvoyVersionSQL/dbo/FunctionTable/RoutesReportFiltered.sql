/****** Object:  TableFunction [dbo].[RoutesReportFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Federico Sobral  
-- Create date: 23/08/2016  
-- Description: <Description,,>  
-- =============================================  
CREATE FUNCTION [dbo].[RoutesReportFiltered]  
(  
  @DateFrom [sys].[datetime]  
 ,@DateTo [sys].[datetime]  
 ,@IdDepartments [sys].[varchar](max) = NULL  
 ,@Types [sys].[varchar](max) = NULL  
 ,@IdPersonsOfInterest [sys].[varchar](max) = NULL  
 ,@IdPointsOfInterest [sys].[varchar](max) = NULL   
 ,@IncludeAutomaticVisits [sys].[bit] = 1  
 ,@QuerySinceStartOfDay [sys].[bit] = 0  
 ,@IdUser [sys].[int] = NULL  
 ,@IncludeDeleted [sys].[int] = 1  
)  
RETURNS TABLE   
AS  
RETURN   
(  
 SELECT COALESCE (R.[IdPersonOfInterest], POIV.[IdPersonOfInterest], RNV.[PersonOfInterestId]) AS PersonOfInterestId,   
   COALESCE (R.[PersonOfInterestName], POIV.[PersonOfInterestName], RNV.[PersonOfInterestName]) AS PersonOfInterestName,   
   COALESCE (R.[PersonOfInterestLastName], POIV.[PersonOfInterestLastName], RNV.[PersonOfInterestLastName]) AS PersonOfInterestLastName,  
   COALESCE (R.[PersonOfInterestIdentifier], POIV.[PersonOfInterestIdentifier], RNV.[PersonOfInterestIdentifier]) AS PersonOfInterestIdentifier,   
   COALESCE (R.[IdPointOfInterest], POIV.[IdPointOfInterest], RNV.[PointOfInterestId]) AS PointOfInterestId,   
   COALESCE (R.[PointOfInterestName], POIV.[PointOfInterestName], RNV.[PointOfInterestName]) AS PointOfInterestName,    
   COALESCE (R.[PointOfInterestIdentifier], POIV.[PointOfInterestIdentifier], RNV.[PointOfInterestIdentifier]) AS PointOfInterestIdentifier,    
   COALESCE (R.[PointOfInterestAddress], POIV.[Address]) AS [PointOfInterestAddress],    
   COALESCE (R.[PointOfInterestLatitude], POIV.[Latitude]) AS [PointOfInterestLatitude],    
   COALESCE (R.[PointOfInterestLongitude], POIV.[Longitude]) AS [PointOfInterestLongitude],    
   COALESCE (R.[PointOfInterestRadius], POIV.[Radius]) AS [PointOfInterestRadius],    
   COALESCE (R.[PointOfInterestMinElapsedTimeForVisit], POIV.[MinElapsedTimeForVisit]) AS [PointOfInterestMinElapsedTimeForVisit],    
   COALESCE (R.[RouteDate],POIV.[DateIn], RNV.RouteDate) AS RouteDate, POIV.[ElapsedTime] AS VisitTime,  
   RNV.[IdRoute] AS RouteNotVisitedId,  
   POIV.[DateIn] AS PointOfInterestVisitedInDate,   
   POIV.[DateOut] AS PointOfInterestVisitedOutDate,  
   0 as IdPointOfInterestVisited,   
   RNV.[Description] AS NoVisitOptionText,  
   RNV.[NoVisitedApprovedState],  
   CASE   
    WHEN R.[RouteDate] IS NULL THEN 3 --Visitado no planificado  
    WHEN RNV.[IdRoute] IS NOT NULL AND RNV.[NoVisitedApprovedState] != 2 THEN 4 --planificado y marcado como no visitado  
    WHEN POIV.[DateIn] IS NULL AND R.[RouteDate] IS NOT NULL THEN 2 --planificado y no visitado  
    WHEN POIV.[DateIn] IS NOT NULL AND R.[RouteDate] IS NOT NULL THEN 1 --visitado y planificado  
    ELSE NULL  
   END AS RouteStatus,  
   '' AS RouteVisitReason,  
   R.[IdRouteDetail] as IdRouteDetail,  
   R.[NoVisitComment] as NoVisitComment,  
   R.[RouteFromHour] as RouteFromHour,  
   R.[RouteToHour] as RouteToHour,  
   R.[ActivityVisitTypeId],  
   POIV.AutomaticValue,  
   RNV.[DateNoVisited],  
   RNV.[IdUserNoVisitedApproved],  
   R.[IdRouteGroup] as IdRouteGroup,  
   R.[RouteGroupName] as RouteGroupName  
  
    
 FROM  [dbo].PointsOfInterestWithActivity(@DateFrom, @DateTo, @IdDepartments, @Types,   
    @IdPersonsOfInterest, @IdPointsOfInterest, @IncludeAutomaticVisits, @IdUser) POIV  
   FULL OUTER JOIN [dbo].[AllRoutesFiltered](IIF(@QuerySinceStartOfDay = 0, @DateFrom, Tzdb.ToUtc(DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(@DateFrom)), 0))), @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest, @IdPointsOfInterest, @IdUser, @IncludeDeleted) R   
    ON (POIV.[IdPersonOfInterest] = R.[IdPersonOfInterest] AND POIV.[IdPointOfInterest] = R.[IdPointOfInterest] AND   
     Tzdb.AreSameSystemDates(POIV.[DateIn], R.[RouteDate]) = 1)  
   FULL OUTER JOIN RoutesMarkedNotVisitedFiltered(@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest, @IdPointsOfInterest, @IdUser) RNV   
    ON (RNV.IdRoute = R.IdRoute AND R.RouteDate = RNV.RouteDate)  
  
 GROUP BY COALESCE (R.[IdPersonOfInterest], POIV.[IdPersonOfInterest], RNV.[PersonOfInterestId]),  
    COALESCE (R.[PersonOfInterestName], POIV.[PersonOfInterestName], RNV.[PersonOfInterestName]),  
    COALESCE (R.[PersonOfInterestLastName], POIV.[PersonOfInterestLastName], RNV.[PersonOfInterestLastName]),  
    COALESCE (R.[PersonOfInterestIdentifier], POIV.[PersonOfInterestIdentifier], RNV.[PersonOfInterestIdentifier]),  
    COALESCE (R.[IdPointOfInterest], POIV.[IdPointOfInterest], RNV.[PointOfInterestId]),  
    COALESCE (R.[PointOfInterestName], POIV.[PointOfInterestName], RNV.[PointOfInterestName]),  
    COALESCE (R.[PointOfInterestIdentifier], POIV.[PointOfInterestIdentifier], RNV.[PointOfInterestIdentifier]),  
    COALESCE (R.[PointOfInterestAddress], POIV.[Address]),  
    COALESCE (R.[PointOfInterestLatitude], POIV.[Latitude]),  
    COALESCE (R.[PointOfInterestLongitude], POIV.[Longitude]),  
    COALESCE (R.[PointOfInterestRadius], POIV.[Radius]),  
    COALESCE (R.[PointOfInterestMinElapsedTimeForVisit], POIV.[MinElapsedTimeForVisit]),  
    COALESCE (R.[RouteDate],POIV.[DateIn], RNV.RouteDate),  
    R.[RouteDate], POIV.[DateIn], POIV.[DateOut], POIV.[ElapsedTime],  
    RNV.[IdRoute], RNV.[Description], RNV.[NoVisitedApprovedState],  
    R.[IdRouteDetail], R.[NoVisitComment],R.[RouteFromHour], R.[RouteToHour], R.[ActivityVisitTypeId], POIV.AutomaticValue,  
    RNV.[DateNoVisited],RNV.[IdUserNoVisitedApproved],R.[IdRouteGroup], R.[RouteGroupName]  
)  
