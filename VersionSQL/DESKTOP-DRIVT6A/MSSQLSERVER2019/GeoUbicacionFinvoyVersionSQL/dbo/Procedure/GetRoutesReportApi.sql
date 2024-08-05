/****** Object:  Procedure [dbo].[GetRoutesReportApi]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: 10/07/2015  
-- Description: SP para obtener el reporte de rutas  
-- =============================================  
CREATE PROCEDURE [dbo].[GetRoutesReportApi]  
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
)  
AS  
BEGIN  
   
 SELECT [PersonOfInterestId], [PersonOfInterestName], [PersonOfInterestLastName],[PersonOfInterestIdentifier],  
   [PointOfInterestId], [PointOfInterestName], [PointOfInterestIdentifier],  
   [RouteDate], [VisitTime], [RouteNotVisitedId], [PointOfInterestVisitedInDate],   
   [PointOfInterestVisitedOutDate], [NoVisitOptionText], [RouteStatus], [RouteVisitReason],   
   [IdRouteDetail], [NoVisitComment], [RouteFromHour], [RouteToHour],   
   [DateNoVisited],[IdUserNoVisitedApproved],[IdRouteGroup] ,[RouteGroupName]   
  
 FROM [dbo].[RoutesReportFiltered](@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest,   
    @IdPointsOfInterest, @IncludeAutomaticVisits, @QuerySinceStartOfDay, @IdUser, 1)  
  
 ORDER BY [RouteDate] DESC, [PointOfInterestName] ASC  
      
END  
  
  
