/****** Object:  Procedure [dbo].[GetRoutesReportAll]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Daniel Artigas  
-- Create date: 12/08/2021  
-- Description: SP para obtener el reporte de rutas  
-- =============================================  
CREATE PROCEDURE [dbo].[GetRoutesReportAll]  
(  
  @DateFrom [sys].[datetime]  
 ,@DateTo [sys].[datetime]  
 ,@IdDepartments [sys].[varchar](max) = NULL  
 ,@Types [sys].[varchar](max) = NULL  
 ,@IdPersonsOfInterest [sys].[varchar](max) = NULL  
 ,@IncludeAutomaticVisits [sys].[bit] = 0  
 ,@QuerySinceStartOfDay [sys].[bit] = 0  
 ,@IdUser [sys].[int] = NULL  
)  
AS  
BEGIN  
  
 DECLARE @IdPointsOfInterest [sys].[varchar](max) = NULL  
   
 SELECT [PersonOfInterestId], [PersonOfInterestName], [PersonOfInterestLastName],[PersonOfInterestIdentifier],  
   [PointOfInterestId], [PointOfInterestName], [PointOfInterestIdentifier],  
   [RouteDate], [VisitTime], [RouteNotVisitedId], [PointOfInterestVisitedInDate],   
   [PointOfInterestVisitedOutDate], [NoVisitOptionText], [RouteStatus], [RouteVisitReason],   
   [IdRouteDetail], [NoVisitComment], [RouteFromHour], [RouteToHour], [AutomaticValue]  
  
 FROM [dbo].[RoutesReportFiltered](@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest,   
    @IdPointsOfInterest, @IncludeAutomaticVisits, @QuerySinceStartOfDay, @IdUser, 1)  
  
 ORDER BY CAST(Tzdb.FromUtc(RouteDate) AS [sys].[date]) DESC, [PointOfInterestName] ASC  
      
END  
  
  
