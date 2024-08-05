/****** Object:  Procedure [dbo].[GetRoutesChartData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:  GL    
-- Create date: 15/10/2015    
-- Description: SP para obtener los datos necesarios para la grafica de rutas del dashboard    
-- =============================================    
CREATE PROCEDURE [dbo].[GetRoutesChartData]    
(    
  @DateFrom [sys].[datetime]    
 ,@DateTo [sys].[datetime]    
 ,@IdDepartments [sys].[varchar](max) = NULL    
 ,@Types [sys].[varchar](max) = NULL    
 ,@IdPersonsOfInterest [sys].[varchar](max) = NULL    
 ,@IdPointsOfInterest [sys].[varchar](max) = NULL    
 ,@IncludeAutomaticVisits [sys].[bit] = 1    
 ,@IdUser [sys].[int] = NULL    
 ,@IncludeDelete [sys].[bit] = 1
)    
AS    
BEGIN    
    
 SELECT SUM(CASE WHEN RouteStatus = 1 THEN 1 ELSE 0 end) AS VisitedAndPlannedQuantity,     
   SUM(CASE WHEN RouteStatus = 4 THEN 1 ELSE 0 end) AS MarkedNoVisitedQuantity,     
   SUM(CASE WHEN RouteStatus = 2 THEN 1 ELSE 0 end) AS PlannedNoVisitedQuantity,     
   SUM(CASE WHEN RouteStatus = 3 THEN 1 ELSE 0 end) AS VisitedNonPlanned    
 FROM [dbo].[RoutesReportFiltered](@DateFrom,@DateTo,@IdDepartments,@Types,@IdPersonsOfInterest,@IdPointsOfInterest,@IncludeAutomaticVisits,DEFAULT,@IdUser,@IncludeDelete)    
     
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
 --  SUM(CASE WHEN R.[RouteDate] IS NULL AND POIV.[LocationInDate] IS NOT NULL THEN 1 ELSE 0 end) AS VisitedNonPlanned    
 --FROM #poi_visited_tmp POIV    
 --  FULL OUTER JOIN #routes_tmp R ON (POIV.[IdPersonOfInterest] = R.[PersonOfInterestId]     
 --  AND POIV.[IdPointOfInterest] = R.[PointOfInterestId] AND     
 --  CAST(POIV.[LocationInDate] AS [sys].[date]) = CAST(R.[RouteDate] AS [sys].[date]))    
 --  FULL OUTER JOIN #routes_not_visited_tmp RNV ON (RNV.Id = R.Id AND R.RouteDate = RNV.RouteDate)    
    
 --DROP TABLE #poi_visited_tmp    
 --DROP TABLE #routes_tmp    
 --DROP TABLE #routes_not_visited_tmp    
      
END
