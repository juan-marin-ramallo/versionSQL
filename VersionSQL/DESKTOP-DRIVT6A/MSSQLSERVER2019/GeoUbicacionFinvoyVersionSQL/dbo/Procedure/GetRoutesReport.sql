/****** Object:  Procedure [dbo].[GetRoutesReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: 10/07/2015  
-- Description: SP para obtener el reporte de rutas  
-- =============================================  
CREATE PROCEDURE [dbo].[GetRoutesReport]  
(  
  @DateFrom [sys].[datetime]  
 ,@DateTo [sys].[datetime]  
 ,@IdDepartments [sys].[varchar](max) = NULL  
 ,@Types [sys].[varchar](max) = NULL  
 ,@IdPersonsOfInterest [sys].[varchar](max) = NULL  
 ,@IdPointsOfInterest [sys].[varchar](max) = NULL  
 ,@IncludeAutomaticVisits [sys].[bit] = 0  
 ,@QuerySinceStartOfDay [sys].[bit] = 0  
 ,@IdUser [sys].[int] = NULL  
)  
AS  
BEGIN  
   
 SELECT [PersonOfInterestId], [PersonOfInterestName], [PersonOfInterestLastName],[PersonOfInterestIdentifier],  
   [PointOfInterestId], [PointOfInterestName], [PointOfInterestIdentifier],  
   [RouteDate], [VisitTime], [RouteNotVisitedId], [PointOfInterestVisitedInDate],   
   [PointOfInterestVisitedOutDate], [NoVisitOptionText], [RouteStatus], [RouteVisitReason],   
   [IdRouteDetail], [NoVisitComment], [RouteFromHour], [RouteToHour], [AutomaticValue]  
  
 FROM [dbo].[RoutesReportFiltered](@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest,   
    @IdPointsOfInterest, @IncludeAutomaticVisits, @QuerySinceStartOfDay, @IdUser, 1)  
  
 ORDER BY CAST(Tzdb.FromUtc(RouteDate) AS [sys].[date]) ASC,CAST(Tzdb.FromUtc(RouteDate) AS [sys].[time]) ASC  
END  
