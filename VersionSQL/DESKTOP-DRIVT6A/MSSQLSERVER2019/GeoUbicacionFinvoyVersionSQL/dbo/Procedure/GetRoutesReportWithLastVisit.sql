/****** Object:  Procedure [dbo].[GetRoutesReportWithLastVisit]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  FS  
-- Create date: 05/11/2019  
-- Description: SP para obtener el reporte de rutas con la última visita  
-- =============================================  
CREATE PROCEDURE [dbo].[GetRoutesReportWithLastVisit]  
(  
  @DateFrom [sys].[DATETIME]   
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
 DECLARE @DateFromVisited [sys].[DATETIME] = DATEADD(month, -6, @DateFrom)  
 DECLARE @PointsOfInterestVisitedSomeWay TABLE  
 (  
   [ActionDate] [sys].[datetime]  
  ,[IdPointOfInterest] [sys].[int]  
  ,[ElapsedTime] [sys].[time]  
  ,[AutomaticValue] [sys].[smallint]  
  ,[Number] [sys].[int]  
 )  
 ;WITH TablePartition AS   
 (   
  SELECT [DateIn] as ActionDate, [IdPointOfInterest], [ElapsedTime], [AutomaticValue],  
     ROW_NUMBER() OVER   
     (   
      PARTITION BY IdPointOfInterest  
      ORDER BY CAST(Tzdb.FromUtc(DateIn) AS [sys].[date]) DESC, AutomaticValue ASC  
     ) AS Number   
  FROM [dbo].PointsOfInterestWithActivity(@DateFromVisited, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest,   
   @IdPointsOfInterest, @IncludeAutomaticVisits, @IdUser) POIV  
 )   
  
 INSERT INTO @PointsOfInterestVisitedSomeWay  
 (  
   [ActionDate], [IdPointOfInterest], [ElapsedTime], [AutomaticValue], [Number]  
 )  
 SELECT * FROM TablePartition WHERE Number = 1   
  
  
 SELECT RR.[PersonOfInterestId], RR.[PersonOfInterestName], RR.[PersonOfInterestLastName],RR.[PersonOfInterestIdentifier],  
   RR.[PointOfInterestId], RR.[PointOfInterestName], RR.[PointOfInterestIdentifier],  
   RR.[RouteDate], RR.[VisitTime], RR.[RouteNotVisitedId], RR.[PointOfInterestVisitedInDate],   
   RR.[PointOfInterestVisitedOutDate], RR.[NoVisitOptionText], RR.[RouteStatus], RR.[RouteVisitReason], RR.[AutomaticValue],  
   RR.[IdRouteDetail], RR.[NoVisitComment], RR.[RouteFromHour], RR.[RouteToHour], POIV.ActionDate [LastVisitRouteDate], POIV.ElapsedTime [LastVisitVisitTime]  
  
 FROM [dbo].[RoutesReportFiltered](@DateFrom, @DateTo, @IdDepartments, @Types, @IdPersonsOfInterest,   
    @IdPointsOfInterest, @IncludeAutomaticVisits, DEFAULT, @IdUser,1) RR  
    LEFT OUTER JOIN @PointsOfInterestVisitedSomeWay POIV ON RR.PointOfInterestId = POIV.IdPointOfInterest  
  
 ORDER BY RR.[RouteDate] DESC, RR.[PointOfInterestName] ASC  
      
END  
  
  
