/****** Object:  Procedure [dbo].[GetDetailRoutesByRouteGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  GL  
-- Create date: 17/08/2016  
-- Description: SP para obtener los detalles de las rutas por día  
-- Change: Matias Corso - 26/10/2016 - Ordeno rutas por fecha y nombre de PDV  
-- Change: Matias Corso - 07/11/2016 - Devuelvo el comentario y si es ruta alternativa  
-- =============================================  
CREATE PROCEDURE [dbo].[GetDetailRoutesByRouteGroup]  
(  
  @StartDate [sys].DATETIME  
 ,@EndDate [sys].DATETIME  
 ,@IdRouteGroup [sys].[int]  
 ,@IdPointsOfInterest [sys].[varchar](1000) = NULL  
 ,@IdUser [sys].[int] = NULL  
)  
AS  
BEGIN  
  
 SELECT  RD.[Id], RP.[IdPointOfInterest], RD.[RouteDate], RD.[IdRoutePointOfInterest],  
    POI.[Name] AS PointOfInterestName, POI.[Identifier] AS PointOfInterestIdentifier,  
    RD.[Disabled], RD.[DisabledType], RP.[AlternativeRoute], RP.[Comment], RD.[FromHour], RD.[ToHour], RD.[Title], RD.[TheoricalMinutes], RD.[IsPriority]
   
 FROM  [dbo].[RouteDetail] RD WITH (NOLOCK)  
    INNER JOIN [dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[Id] = RD.[IdRoutePointOfInterest]  
    INNER JOIN [dbo].[RouteGroup] RG WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup]  
    INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON  POI.[Id] = RP.[IdPointOfInterest]  
   
 WHERE   (CAST(RD.[RouteDate] AS [sys].[date]) <= CAST(@EndDate AS [sys].[date])) AND  
    (CAST(RD.[RouteDate] AS [sys].[date]) >= CAST(@StartDate AS [sys].[date])) AND  
    ((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(RP.[IdPointOfInterest], @IdPointsOfInterest) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(POI.[Id], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(POI.[IdDepartment], @IdUser) = 1))  
    AND POI.[Deleted] = 0 AND (RP.[Deleted] = 0 OR RP.[AlternativeRoute] = 1)  
    AND RG.[Id] = @IdRouteGroup AND RG.[Deleted] = 0  
  
 GROUP BY RD.[Id], RP.[IdPointOfInterest], RD.[RouteDate], RD.[IdRoutePointOfInterest],  
    POI.[Name], POI.[Identifier], RD.[Disabled], RD.[DisabledType], RP.[AlternativeRoute], RP.[Comment],   
    RD.[FromHour], RD.[ToHour], RD.[Title], RD.[TheoricalMinutes], RD.[IsPriority]
   
 ORDER BY RD.[RouteDate], POI.[Identifier] , POI.[Name]  
   
END
