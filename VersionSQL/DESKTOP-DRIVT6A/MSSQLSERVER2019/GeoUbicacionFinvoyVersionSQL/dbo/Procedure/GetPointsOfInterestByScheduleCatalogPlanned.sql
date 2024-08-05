/****** Object:  Procedure [dbo].[GetPointsOfInterestByScheduleCatalogPlanned]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Juan Marin 
-- Create date: 20/01/2024  
-- Description: SP para obtener los puntos de interés por Catalogo Planificado en los Cronogramas de Actividades
-- =============================================  
CREATE PROCEDURE [dbo].[GetPointsOfInterestByScheduleCatalogPlanned]  
(  
  @IdCatalogs [sys].[varchar](max) = NULL  
 ,@IdUser [sys].[int] = NULL  
)  
AS  
BEGIN  
 SELECT  P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude],   
    P.[Radius], P.[MinElapsedTimeForVisit], P.[NFCTagId],  
    P.[IdDepartment], D.[Name] AS DepartmentName,  
    PZ.IdZone, P.[ContactName], P.[ContactPhoneNumber],  
    P.[GrandfatherId] AS HierarchyLevel1Id, P.[FatherId] AS HierarchyLevel2Id, P.[Emails]  
        
 FROM  [dbo].[PointOfInterest] P WITH(NOLOCK)  
	INNER JOIN	dbo.CatalogPointOfInterest CPOI WITH(NOLOCK) ON CPOI.IdPointOfInterest = P.Id
    LEFT OUTER JOIN dbo.PointOfInterestZone PZ WITH(NOLOCK) ON PZ.IdPointOfInterest = P.Id  
    LEFT OUTER JOIN dbo.Department D WITH(NOLOCK) ON D.Id = P.IdDepartment  
  
 WHERE  P.[Deleted] = 0 AND  
    ((@IdCatalogs IS NULL) OR (dbo.CheckValueInList(CPOI.[IdCatalog], @IdCatalogs) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))  
   
 GROUP BY P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit],   
    P.[IdDepartment], D.[Name], P.[NFCTagId],  
    PZ.IdZone, P.[ContactName], P.[ContactPhoneNumber],  
    P.[GrandfatherId], P.[FatherId], P.[Emails]  
END
