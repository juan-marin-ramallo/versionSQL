/****** Object:  Procedure [dbo].[DashboardRoutesIndicator]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  NR  
-- Create date: 11/10/2019  
-- Description: SP para obtener indicador de rutas  
-- =============================================  
CREATE PROCEDURE [dbo].[DashboardRoutesIndicator]  
(  
  @DateFrom [sys].[datetime]  
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
  
 -- Report  
 SELECT    
   ISNULL(SUM ( IIF([RouteStatus] = 1, 1, 0)), 0) AS [Visited],  
   ISNULL(SUM ( IIF([RouteStatus] = 4, 1, 0)), 0) AS [NotVisited],  
   ISNULL(SUM ( IIF([RouteStatus] = 2, 1, 0)), 0) AS [Pending],  
   ISNULL(SUM ( IIF([RouteStatus] = 3, 1, 0)), 0) AS [NotPlanned]  
 FROM [dbo].[RoutesReportFiltered](@DateFrom,@DateTo,@IdDepartments,@Types,@IdPersonsOfInterest,@IdPointsOfInterest,@IncludeAutomaticVisits,DEFAULT,@IdUser,1)  
   
      
END  
  
  
