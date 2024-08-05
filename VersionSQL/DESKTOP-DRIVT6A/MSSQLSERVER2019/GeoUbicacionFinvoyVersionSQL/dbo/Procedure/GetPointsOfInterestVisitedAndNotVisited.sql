/****** Object:  Procedure [dbo].[GetPointsOfInterestVisitedAndNotVisited]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: 10/07/2015  
-- Description: SP para obtener tanto los POI visitados como los que debia visitar y no fueron visitados.  
-- =============================================  
CREATE PROCEDURE [dbo].[GetPointsOfInterestVisitedAndNotVisited]  
(  
  @DateFrom [sys].[DATETIME]  
 ,@DateTo [sys].[DATETIME]  
 ,@IdDepartments [sys].[VARCHAR](MAX) = NULL  
 ,@Types [sys].[VARCHAR](MAX) = NULL  
 ,@IdPersonsOfInterest [sys].[VARCHAR](MAX) = NULL  
 ,@IdPointsOfInterest [sys].[VARCHAR](MAX) = NULL  
 ,@IdUser [sys].[INT] = NULL  
 ,@IncludeAutomaticVisits [sys].[BIT] = 1  
)  
AS  
BEGIN  
  
 SELECT  R.[PointOfInterestId] AS Id,   
    R.[PointOfInterestName] AS Name,   
    R.[PointOfInterestAddress] AS Address,  
    R.[PointOfInterestLatitude] AS Latitude,   
    R.[PointOfInterestLongitude] AS Longitude,    
    R.[PointOfInterestRadius] AS Radius,  
    R.[PointOfInterestMinElapsedTimeForVisit] AS MinElapsedTimeForVisit,  
    --R.[PointOfInterestIdDepartment] AS IdDepartment,  
    R.[PointOfInterestIdentifier] AS Identifier,   
    CASE   
     WHEN R.[PointOfInterestVisitedInDate] IS NULL AND R.[RouteDate] IS NOT NULL THEN 'False' --planificado y no visitado  
     WHEN R.[PointOfInterestVisitedInDate] IS NOT NULL AND r.[RouteDate] IS NOT NULL THEN 'True' --visitado y planificado  
     WHEN R.[RouteDate] IS NULL THEN 'True' --Visitado no planificado  
     ELSE NULL  
    END AS Visited  
  
 FROM  [dbo].[RoutesReportFiltered](@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest, @IdPointsOfInterest, @IncludeAutomaticVisits, 0, @IdUser, 1) R  
  
 GROUP BY R.[PointOfInterestId],  
    R.[PointOfInterestName],  
    R.[PointOfInterestAddress],  
    R.[PointOfInterestLatitude],  
    R.[PointOfInterestLongitude],  
    R.[PointOfInterestRadius],  
    R.[PointOfInterestMinElapsedTimeForVisit],  
    --R.[PointOfInterestIdDepartment],  
    R.[PointOfInterestIdentifier],  
    CASE   
     WHEN R.[PointOfInterestVisitedInDate] IS NULL AND r.[RouteDate] IS NOT NULL THEN 'False' --planificado y no visitado  
     WHEN R.[PointOfInterestVisitedInDate] IS NOT NULL AND r.[RouteDate] IS NOT NULL THEN 'True' --visitado y planificado  
     WHEN R.[RouteDate] IS NULL THEN 'True' --Visitado no planificado  
     ELSE NULL  
    END   
  
 ---- Points of Interest Visited  
 --create table #poi_visited_tmp ([Id] [sys].[int], [Name] [sys].[varchar](100), [Address] [sys].[varchar](250),   
 --[Latitude] [sys].[decimal](25,20), [Longitude] [sys].[decimal](25,20), [Radius] [sys].[int],   
 --[MinElapsedTimeForVisit] [sys].[int], [IdDepartment] [sys].[INT], [ActionDate] [sys].[datetime],  
 --[IdPersonOfInterest] [sys].[int],[Identifier] [sys].[varchar](50))  
  
 --INSERT INTO #poi_visited_tmp   
 -- SELECT P.[IdPointOfInterest], P.[PointOfInterestName],   
 --   P.[Address], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit], P.[IdDepartment],  
 --   P.[ActionDate], P.[IdPersonOfInterest] AS IdPersonOfInterest, P.[PointOfInterestIdentifier]  
 --FROM  [dbo].PointsOfInterestVisitedAnyWay(@DateFrom,@DateTo,@IdDepartments,@Types,@IdPersonsOfInterest,@IdPointsOfInterest,@IncludeAutomaticVisits,@IdUser) P  
  
 ---- Routes planned  
 --create table #routes_tmp ([Id] [sys].[int], [RouteDate] [sys].[datetime],  
 -- [PointOfInterestId] [sys].[int], [PointOfInterestName] [sys].[varchar](100),   
 -- [PointOfInterestAddress] [sys].[varchar](250),[PointOfInterestLatitude] [sys].[decimal](25,20), [PointOfInterestLongitude] [sys].[decimal](25,20),   
 -- [PointOfInterestRadius] [sys].[int], [POIMinElapsedTimeForVisit] [sys].[int], [IdDepartment] [sys].[int],[PersonOfInterestId] [sys].[int], [Identifier] [sys].[varchar](250))  
  
 -- INSERT INTO #routes_tmp   
 -- EXEC [dbo].[GetPointOfInterestFromRoute] @DateFrom ,@DateTo ,@IdDepartments ,@Types ,@IdPersonsOfInterest   
 -- ,@IdPointsOfInterest ,@IdUser  
   
 --SELECT  COALESCE (R.[PointOfInterestId], POIV.[Id]) AS Id,   
 --   COALESCE (R.[PointOfInterestName], POIV.[Name]) AS Name,   
 --   COALESCE (R.[PointOfInterestAddress], POIV.[Address]) AS Address,  
 --   COALESCE (R.[PointOfInterestLatitude], POIV.[Latitude]) AS Latitude,   
 --   COALESCE (R.[PointOfInterestLongitude], POIV.[Longitude]) AS Longitude,    
 --   COALESCE(R.[PointOfInterestRadius],POIV.[Radius]) AS Radius,  
 --   COALESCE(R.[POIMinElapsedTimeForVisit],POIV.[MinElapsedTimeForVisit]) AS MinElapsedTimeForVisit,  
 --   COALESCE(R.[IdDepartment],POIV.[IdDepartment]) AS IdDepartment,  
 --   COALESCE (R.[Identifier], POIV.[Identifier]) AS Identifier,    
 --   CASE   
 --    WHEN POIV.[ActionDate] IS NULL AND r.[RouteDate] IS NOT NULL THEN 'False' --planificado y no visitado  
 --    WHEN POIV.[ActionDate] IS NOT NULL AND r.[RouteDate] IS NOT NULL THEN 'True' --visitado y planificado  
 --    WHEN R.[RouteDate] IS NULL THEN 'True' --Visitado no planificado  
 --    ELSE NULL  
 --   END AS Visited  
  
 --FROM  #poi_visited_tmp POIV  
 --   FULL OUTER JOIN #routes_tmp R ON (POIV.[IdPersonOfInterest] = R.[PersonOfInterestId]   
 --   AND POIV.[Id] = R.[PointOfInterestId] AND   
 --   Tzdb.AreSameSystemDates(POIV.[ActionDate], R.[RouteDate]) = 1)  
  
 --GROUP BY COALESCE (R.[PointOfInterestId], POIV.[Id]),   
 --   COALESCE (R.[PointOfInterestName], POIV.[Name]),   
 --   COALESCE (R.[PointOfInterestAddress], POIV.[Address]),  
 --   COALESCE (R.[PointOfInterestLatitude], POIV.[Latitude]),   
 --   COALESCE (R.[PointOfInterestLongitude], POIV.[Longitude]) ,    
 --   COALESCE(R.[PointOfInterestRadius],POIV.[Radius]),  
 --   COALESCE(R.[POIMinElapsedTimeForVisit],POIV.[MinElapsedTimeForVisit]),  
 --   COALESCE(R.[IdDepartment],POIV.[IdDepartment]),  
 --   COALESCE (R.[Identifier], POIV.[Identifier]),  
 --   CASE   
 --    WHEN POIV.[ActionDate] IS NULL AND r.[RouteDate] IS NOT NULL THEN 'False' --planificado y no visitado  
 --    WHEN POIV.[ActionDate] IS NOT NULL AND r.[RouteDate] IS NOT NULL THEN 'True' --visitado y planificado  
 --    WHEN R.[RouteDate] IS NULL THEN 'True' --Visitado no planificado  
 --    ELSE NULL  
 --   END   
  
 --DROP TABLE #poi_visited_tmp  
 --DROP TABLE #routes_tmp  
  
END  
  
  
  
  
