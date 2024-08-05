/****** Object:  Procedure [dbo].[GetPointsOfInterestExcel]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Jesús Portillo  
-- Create date: 01/10/2012  
-- Description: SP para obtener los puntos de interés  
-- =============================================  
CREATE PROCEDURE [dbo].[GetPointsOfInterestExcel]  
(  
  @IdPointsOfInterest [sys].[varchar](max) = NULL  
 ,@IdUser [sys].[int] = NULL  
)  
AS  
BEGIN  
 SELECT  P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude],   
    P.[Radius], P.[MinElapsedTimeForVisit], P.[NFCTagId],  
    P.[IdDepartment], D.[Name] AS DepartmentName, P.[ContactName], P.[ContactPhoneNumber],  
    CA.[Name] AS CustomAttributeName, ISNULL(CAO.[Text], CAV.[Value]) AS CustomAttributeValue, CA.[Id] AS CustomAttributeId, CA.[IdValueType] AS CustomAttributeIdValueType,  
    H1.[Id] AS IdHierarchyLevel1, H1.[Name] AS HierarchyLevel1Name,  
    H2.[Id] AS IdHierarchyLevel2, H2.[Name] AS HierarchyLevel2Name, P.[ZonesList], P.[Emails],P.[IdPersonOfInterest],PO.[Name] as NamePersonOfInterest,PO.[LastName] as LastNamePersonOfInterest,PO.[Identifier] as IdentifierPersonOfInterest  
        
  
 FROM  [dbo].[PointOfInterestWithZone] P  
    LEFT OUTER JOIN dbo.Department D ON D.Id = P.IdDepartment  
    LEFT JOIN [dbo].[CustomAttributeValue] CAV ON CAV.[IdPointOfInterest] = P.[Id]  
    LEFT JOIN [dbo].[CustomAttributeOption] CAO ON CAV.[IdCustomAttributeOption] = CAO.[Id]  
    LEFT JOIN [dbo].[CustomAttribute] CA ON CAV.[IdCustomAttribute] = CA.[Id] AND CA.[Deleted] = 0  
    LEFT JOIN [dbo].[POIHierarchyLevel1] H1 ON H1.[Id] = P.[GrandfatherId]  
    LEFT JOIN [dbo].[POIHierarchyLevel2] H2 ON H2.[Id] = P.[FatherId]  
    LEFT JOIN [dbo].[PersonOfInterest] PO on PO.Id = p.IdPersonOfInterest  
  
 WHERE  P.[Deleted] = 0 AND  
    ((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))  
   
 GROUP BY P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit],   
    P.[IdDepartment], D.[Name], P.[NFCTagId], P.[ContactName], P.[ContactPhoneNumber],  
    CA.[Name], ISNULL(CAO.[Text], CAV.[Value]), CA.[IdValueType], CA.[Id], H1.[Id], H1.[Name], H2.[Id], H2.[Name], P.[ZonesList], P.[Emails],P.[IdPersonOfInterest],PO.[Name],PO.[LastName],PO.[Identifier]  
  
 order by P.[Id]  
END
