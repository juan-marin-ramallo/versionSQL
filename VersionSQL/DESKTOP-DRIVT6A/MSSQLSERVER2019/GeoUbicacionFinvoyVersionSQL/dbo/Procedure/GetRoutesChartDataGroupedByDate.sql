/****** Object:  Procedure [dbo].[GetRoutesChartDataGroupedByDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: 04/12/2015  
-- Description: SP para obtener los datos necesarios para la grafica de rutas de linea en el reporte de rutas  
-- =============================================  
CREATE PROCEDURE [dbo].[GetRoutesChartDataGroupedByDate]  
(  
  @DateFrom [sys].[datetime]  
 ,@DateTo [sys].[datetime]  
 ,@IdDepartments [sys].[varchar](max) = NULL  
 ,@Types [sys].[varchar](max) = NULL  
 ,@IdPersonsOfInterest [sys].[varchar](max) = NULL  
 ,@IdPointsOfInterest [sys].[varchar](max) = NULL  
 ,@IncludeAutomaticVisits [sys].[bit] = 1  
 ,@IdUser [sys].[int] = NULL  
)  
AS  
BEGIN  
   
 SELECT SUM(CASE WHEN RouteStatus = 1 THEN 1 ELSE 0 end) AS VisitedAndPlannedQuantity,   
   SUM(CASE WHEN RouteStatus = 4 THEN 1 ELSE 0 end) AS MarkedNoVisitedQuantity,   
   SUM(CASE WHEN RouteStatus = 2 THEN 1 ELSE 0 end) AS PlannedNoVisitedQuantity,   
   SUM(CASE WHEN RouteStatus = 3 THEN 1 ELSE 0 end) AS VisitedNonPlanned,  
   SelectedDate  
 FROM (  
  SELECT RouteStatus, Tzdb.ToUtc(CAST(Tzdb.FromUtc(ISNULL([RouteDate], PointOfInterestVisitedInDate)) AS [sys].[date])) as SelectedDate  
  FROM [dbo].[RoutesReportFiltered](@DateFrom,@DateTo,@IdDepartments,@Types,@IdPersonsOfInterest,@IdPointsOfInterest,@IncludeAutomaticVisits,DEFAULT,@IdUser,1)  
  ) as R  
 GROUP BY SelectedDate  
  
 --SELECT SUM(CASE WHEN RouteStatus = 1 THEN 1 ELSE 0 end) AS VisitedAndPlannedQuantity,   
 --  SUM(CASE WHEN RouteStatus = 4 THEN 1 ELSE 0 end) AS MarkedNoVisitedQuantity,   
 --  SUM(CASE WHEN RouteStatus = 2 THEN 1 ELSE 0 end) AS PlannedNoVisitedQuantity,   
 --  SUM(CASE WHEN RouteStatus = 3 THEN 1 ELSE 0 end) AS VisitedNonPlanned,  
 --  Tzdb.ToUtc(CAST(Tzdb.FromUtc(ISNULL([RouteDate], PointOfInterestVisitedInDate)) AS [sys].[date])) as SelectedDate  
 --FROM [dbo].[RoutesReportFiltered](@DateFrom,@DateTo,@IdDepartments,@Types,@IdPersonsOfInterest,@IdPointsOfInterest,@IncludeAutomaticVisits,DEFAULT,@IdUser)  
 --GROUP BY Tzdb.ToUtc(CAST(Tzdb.FromUtc(ISNULL([RouteDate], PointOfInterestVisitedInDate)) AS [sys].[date]))  
  
 ---- Points of Interest Visited  
 --create table #poi_visited_tmp ([Id] [sys].[int], [IdPersonOfInterest] [sys].[int], [PersonOfInterestName] [sys].[varchar](50),   
 --[PersonOfInterestLastName] [sys].[varchar](50), [IdLocationIn] [sys].[int], [LocationInDate] [sys].[datetime],   
 --[IdLocationOut] [sys].[int], [LocationOutDate] [sys].[datetime], [IdPointOfInterest] [sys].[int],   
 --PointOfInterestName [sys].[varchar](100), [ElapsedTime] [sys].[time](7), [Latitude] [sys].[decimal](25,20),   
 --[Longitude] [sys].[decimal](25,20),[PointOfInterestIdentifier] [sys].[varchar](50))  
  
 --INSERT INTO #poi_visited_tmp   
 -- EXEC [dbo].[GetPointsOfInterestVisited] @DateFrom ,@DateTo ,@IdDepartments ,@Types ,@IdPersonsOfInterest   
 -- ,@IdPointsOfInterest ,@IdUser  
  
 ---- Routes planned  
 --create table #routes_tmp ([Id] [sys].[int], [RouteDate] [sys].[datetime],  
 -- [PersonOfInterestId] [sys].[int], [PersonOfInterestName] [sys].[varchar](50),   
 -- [PersonOfInterestLastName] [sys].[varchar](50), [PointOfInterestId] [sys].[int],   
 -- PointOfInterestName [sys].[varchar](100),[PointOfInterestIdentifier] [sys].[varchar](50))  
  
 -- INSERT INTO #routes_tmp   
 -- EXEC [dbo].[GetAllRoutesReport] @DateFrom ,@DateTo ,@IdDepartments ,@Types ,@IdPersonsOfInterest   
 -- ,@IdPointsOfInterest ,@IdUser  
  
 --/* CAMBIO DADO 18-08-2016 Por No Visita marcada por mercaderista*/  
 ---- Rutas marcadas como no visitadas  
 --create table #routes_not_visited_tmp ([Id] [sys].[int], [RouteDate] [sys].[datetime],  
 -- [PersonOfInterestId] [sys].[int], [PersonOfInterestName] [sys].[varchar](50),   
 -- [PersonOfInterestLastName] [sys].[varchar](50), [PointOfInterestId] [sys].[int],   
 -- PointOfInterestName [sys].[varchar](100),[PointOfInterestIdentifier] [sys].[varchar](50)  
 --   ,[Description] [sys].[varchar](50), [NoVisitedApprovedState] [sys].[smallint])  
  
 -- INSERT INTO #routes_not_visited_tmp   
 -- EXEC [dbo].[GetRoutesMarkedNotVisited] @DateFrom ,@DateTo ,@IdDepartments ,@Types ,@IdPersonsOfInterest   
 -- ,@IdPointsOfInterest ,@IdUser  
   
  
 --SELECT SUM(CASE WHEN POIV.[LocationInDate] IS NOT NULL AND r.[RouteDate] IS NOT NULL THEN 1 ELSE 0 end) AS VisitedAndPlannedQuantity,   
 --  SUM(CASE WHEN RNV.ID IS NOT NULL THEN 1 ELSE 0 end) AS MarkedNoVisitedQuantity,   
 --  SUM(CASE WHEN POIV.[LocationInDate] IS NULL AND R.[RouteDate] IS NOT NULL AND RNV.Id IS NULL THEN 1 ELSE 0 end) AS PlannedNoVisitedQuantity,   
 --  SUM(CASE WHEN R.[RouteDate] IS NULL AND POIV.[LocationInDate] IS NOT NULL THEN 1 ELSE 0 end) AS VisitedNonPlanned,  
 --  CAST(  
 --            CASE   
 --                 WHEN R.[RouteDate] IS NULL   
 --                    THEN  POIV.[LocationInDate]   
 --                 ELSE R.[RouteDate]   
 --            END AS [sys].[date]) as SelectedDate  
 --FROM #poi_visited_tmp POIV  
 --  FULL OUTER JOIN #routes_tmp R ON (POIV.[IdPersonOfInterest] = R.[PersonOfInterestId]   
 --  AND POIV.[IdPointOfInterest] = R.[PointOfInterestId] AND   
 --  CAST(POIV.[LocationInDate] AS [sys].[date]) = CAST(R.[RouteDate] AS [sys].[date]))  
 --  FULL OUTER JOIN #routes_not_visited_tmp RNV ON (RNV.Id = R.Id AND R.RouteDate = RNV.RouteDate)  
 --GROUP BY CAST(  
 --            CASE   
 --                 WHEN R.[RouteDate] IS NULL   
 --                    THEN  POIV.[LocationInDate]   
 --                 ELSE R.[RouteDate]   
 --            END AS [sys].[date])  
  
 --DROP TABLE #poi_visited_tmp  
 --DROP TABLE #routes_tmp  
 --DROP TABLE #routes_not_visited_tmp  
     
END  
  
  
  
