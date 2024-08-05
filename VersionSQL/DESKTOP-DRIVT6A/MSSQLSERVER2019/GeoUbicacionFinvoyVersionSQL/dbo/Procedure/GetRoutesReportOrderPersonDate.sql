/****** Object:  Procedure [dbo].[GetRoutesReportOrderPersonDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: 08/06/2016  
-- Description: SP para obtener los puntos de interés visitados ORDENADOS por persona y por dia  
-- =============================================  
CREATE PROCEDURE [dbo].[GetRoutesReportOrderPersonDate]  
(  
  @DateFrom [sys].[datetime]  
 ,@DateTo [sys].[datetime]  
 ,@IdDepartments [sys].[varchar](max) = NULL  
 ,@Types [sys].[varchar](max) = NULL  
 ,@IdPersonsOfInterest [sys].[varchar](max) = NULL   
 ,@IdUser [sys].[int] = NULL  
 ,@IncludeAutomaticVisits [sys].[bit] = 1  
 ,@QuerySinceStartOfDay [sys].[bit] = 0  
)  
AS  
BEGIN   
 SELECT [PersonOfInterestId], [PersonOfInterestName], [PersonOfInterestLastName],[PersonOfInterestIdentifier],  
   [PointOfInterestId], [PointOfInterestName], [PointOfInterestIdentifier],  
   [RouteDate], [VisitTime], [RouteNotVisitedId], [PointOfInterestVisitedInDate],   
   [PointOfInterestVisitedOutDate], [NoVisitOptionText], [RouteStatus], [RouteVisitReason],   
   [IdRouteDetail], [NoVisitComment], [RouteFromHour], [RouteToHour], [AutomaticValue]  
  
 FROM [dbo].[RoutesReportFiltered](@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest,   
    DEFAULT, @IncludeAutomaticVisits, @QuerySinceStartOfDay, @IdUser, 1)  
    --[RoutesReportVisitedDaysFiltered]  
 ORDER BY [PersonOfInterestId] ASC, ISNULL([PointOfInterestVisitedInDate], RouteDate) ASC  
END  
  
  
  
