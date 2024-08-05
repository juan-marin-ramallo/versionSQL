/****** Object:  Procedure [dbo].[GetRoutesReportGroupedByPOI]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: 10/07/2015  
-- Description: SP para obtener el reporte de rutas  
-- =============================================  
CREATE PROCEDURE [dbo].[GetRoutesReportGroupedByPOI]  
(  
  @DateFrom [sys].[DATETIME]  
 ,@DateTo [sys].[DATETIME]  
 ,@IdDepartments [sys].[VARCHAR](MAX) = NULL  
 ,@Types [sys].[VARCHAR](MAX) = NULL  
 ,@IdPersonsOfInterest [sys].[VARCHAR](MAX) = NULL  
 ,@IdPointsOfInterest [sys].[VARCHAR](MAX) = NULL  
 ,@IncludeAutomaticVisits [sys].[BIT] = 1  
 ,@IdUser [sys].[INT] = NULL  
)  
AS  
BEGIN  
  
 -- Report  
 SELECT  Tzdb.ToUtc(CAST(Tzdb.FromUtc([RouteDate]) AS [sys].[DATE])) AS [Date], [PointOfInterestId], [PointOfInterestName],  
   SUM ( IIF([RouteStatus] = 1, 1, 0)) AS [Visited],  
   SUM ( IIF([RouteStatus] IN (2, 4), 1, 0)) AS [NotVisited],  
   SUM ( IIF([RouteStatus] = 3, 1, 0)) AS [NotPlanned]  
 FROM [dbo].[RoutesReportFiltered](@DateFrom,@DateTo,@IdDepartments,@Types,@IdPersonsOfInterest,@IdPointsOfInterest,@IncludeAutomaticVisits,DEFAULT,@IdUser,1)  
 GROUP BY Tzdb.ToUtc(CAST(Tzdb.FromUtc([RouteDate]) AS [sys].[date])), [PointOfInterestId], [PointOfInterestName]  
 ORDER BY Tzdb.ToUtc(CAST(Tzdb.FromUtc([RouteDate]) AS [sys].[date])) ASC  
      
END  
  
  
