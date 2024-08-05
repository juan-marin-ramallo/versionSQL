/****** Object:  Procedure [dbo].[GetRoutesChartDataGrouped]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: 15/10/2015  
-- Description: SP para obtener los datos necesarios para la grafica de rutas para la ppt  
-- =============================================  
CREATE PROCEDURE [dbo].[GetRoutesChartDataGrouped]  
(  
  @DateFrom [sys].[DATETIME]  
 ,@DateTo [sys].[DATETIME]  
 ,@IdDepartments [sys].[VARCHAR](MAX) = NULL  
 ,@IdPersonsOfInterest [sys].[VARCHAR](MAX) = NULL  
 ,@IdPointsOfInterest [sys].[VARCHAR](MAX) = NULL  
 ,@IdZone [sys].[VARCHAR](MAX) = NULL  
 ,@IncludeAutomaticVisits [sys].[BIT] = 1  
 ,@IdUser [sys].[INT] = NULL  
)  
AS  
BEGIN  
  
 SELECT  SUM(RD.VisitedAndPlannedQuantity) AS VisitedAndPlannedQuantity,   
   SUM(RD.MarkedNoVisitedQuantity) AS MarkedNoVisitedQuantity,   
   SUM(RD.PlannedNoVisitedQuantity) AS PlannedNoVisitedQuantity,   
   SUM(RD.VisitedNonPlanned) AS VisitedNonPlanned  
 FROM (  
  SELECT R.PersonOfInterestId, R.[PersonOfInterestName], R.[PersonOfInterestLastName],  
    SUM(CASE WHEN R.RouteStatus = 1 THEN 1 ELSE 0 end) AS VisitedAndPlannedQuantity,   
    SUM(CASE WHEN R.RouteStatus = 4 THEN 1 ELSE 0 end) AS MarkedNoVisitedQuantity,   
    SUM(CASE WHEN R.RouteStatus = 2 THEN 1 ELSE 0 end) AS PlannedNoVisitedQuantity,   
    SUM(CASE WHEN R.RouteStatus = 3 THEN 1 ELSE 0 end) AS VisitedNonPlanned  
  FROM [dbo].[RoutesReportFiltered](@DateFrom,@DateTo,@IdDepartments, NULL, @IdPersonsOfInterest, @IdPointsOfInterest, @IncludeAutomaticVisits, DEFAULT, @IdUser,1) R  
  GROUP BY R.PersonOfInterestId, R.[PersonOfInterestName], R.[PersonOfInterestLastName]  
  HAVING @IdZone IS NULL OR EXISTS (SELECT 1 FROM [dbo].[PersonOfInterestZone] Z   
  WHERE R.PersonOfInterestId = Z.IdPersonOfInterest   
    AND [dbo].[CheckValueInList](Z.IdZone, @IdZone) > 0)  
 ) AS RD  
  
END  
  
