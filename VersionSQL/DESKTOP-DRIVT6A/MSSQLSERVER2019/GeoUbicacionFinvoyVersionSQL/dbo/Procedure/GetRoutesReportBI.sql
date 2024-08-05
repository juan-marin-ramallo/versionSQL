/****** Object:  Procedure [dbo].[GetRoutesReportBI]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  JP  
-- Create date: 28/11/2018  
-- Description: SP para obtener el reporte de rutas  
-- =============================================  
CREATE PROCEDURE [dbo].[GetRoutesReportBI]  
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
 SET @DateFrom = Tzdb.ToUtc(@DateTo)  
 SET @DateTo = Tzdb.ToUtc(@DateTo)  
   
 SELECT [PersonOfInterestId], [PersonOfInterestName], [PersonOfInterestLastName],[PersonOfInterestIdentifier],  
   [PointOfInterestId], [PointOfInterestName], [PointOfInterestIdentifier],  
   Tzdb.FromUtc([RouteDate]) AS RouteDate, [VisitTime], [RouteNotVisitedId], Tzdb.FromUtc([PointOfInterestVisitedInDate]) AS PointOfInterestVisitedInDate,  
   Tzdb.FromUtc([PointOfInterestVisitedOutDate]) AS PointOfInterestVisitedOutDate, [NoVisitOptionText], [RouteStatus], [RouteVisitReason],  
   [IdRouteDetail], [NoVisitComment], [RouteFromHour], [RouteToHour]  
 FROM [dbo].[RoutesReportFiltered](@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest,  
    @IdPointsOfInterest, @IncludeAutomaticVisits, DEFAULT, @IdUser, 1)  
 ORDER BY [PointOfInterestName], [RouteDate] ASC  
      
END  
  
  
