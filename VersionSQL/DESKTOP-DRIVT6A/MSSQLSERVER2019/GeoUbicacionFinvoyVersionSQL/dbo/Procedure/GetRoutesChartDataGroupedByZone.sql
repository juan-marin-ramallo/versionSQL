/****** Object:  Procedure [dbo].[GetRoutesChartDataGroupedByZone]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: 15/10/2015  
-- Description: SP para obtener los datos necesarios para la grafica de rutas para la ppt  
-- =============================================  
CREATE PROCEDURE [dbo].[GetRoutesChartDataGroupedByZone]  
(  
  @DateFrom [sys].[datetime]  
 ,@DateTo [sys].[datetime]  
 ,@IdDepartments [sys].[varchar](max) = NULL  
 ,@IdPersonsOfInterest [sys].[varchar](max) = NULL  
 ,@IdPointsOfInterest [sys].[varchar](max) = NULL  
 ,@IdZone [sys].[varchar](max) = NULL  
 ,@IncludeAutomaticVisits [sys].[bit] = 1  
 ,@IdUser [sys].[int] = NULL  
)  
AS  
BEGIN  
  
 SELECT Z.[Id] AS ZoneId, Z.[Description] AS ZoneDescription, Z.[ApplyToAllPersonOfInterest],  
   SUM(CASE WHEN R.RouteStatus = 1 THEN 1 ELSE 0 end) AS VisitedAndPlannedQuantity,   
   SUM(CASE WHEN R.RouteStatus = 4 THEN 1 ELSE 0 end) AS MarkedNoVisitedQuantity,   
   SUM(CASE WHEN R.RouteStatus = 2 THEN 1 ELSE 0 end) AS PlannedNoVisitedQuantity,   
   SUM(CASE WHEN R.RouteStatus = 3 THEN 1 ELSE 0 end) AS VisitedNonPlanned  
 FROM [dbo].[RoutesReportFiltered](@DateFrom,@DateTo, @IdDepartments, NULL, @IdPersonsOfInterest, @IdPointsOfInterest, @IncludeAutomaticVisits, DEFAULT, @IdUser,1) R  
   JOIN [dbo].[PersonOfInterestZone] PZ WITH (NOLOCK) ON R.PersonOfInterestId = PZ.IdPersonOfInterest   
   JOIN [dbo].[ZoneTranslated] Z WITH (NOLOCK) ON PZ.IdZone = Z.Id   
 WHERE (@IdZone IS NULL OR [dbo].[CheckValueInList](PZ.IdZone, @IdZone) > 0) AND Z.ApplyToAllPointOfInterest = 0 AND Z.ApplyToAllPersonOfInterest = 0  
 GROUP BY Z.[Id],Z.[Description],Z.[ApplyToAllPersonOfInterest]  
END  
