/****** Object:  Procedure [dbo].[GetPointsOfInterestForTemplate]    Committed by VersionSQL https://www.versionsql.com ******/

-- GetPointsOfInterestForTemplate null, 1
-- =============================================  
-- Author:  Jesús Portillo  
-- Create date: 08/09/2020  
-- Description: SP para obtener los puntos de interés para cargar en template excel  
-- =============================================  
CREATE PROCEDURE [dbo].[GetPointsOfInterestForTemplate]  
(  
  @IdPointsOfInterest [sys].[varchar](max) = NULL  
 ,@IdUser [sys].[int] = NULL  
)  
AS  
BEGIN  
 SELECT  P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude],  
    P.[Radius], P.[MinElapsedTimeForVisit], P.[NFCTagId],  
    P.[IdDepartment], P.[ContactName], P.[ContactPhoneNumber],  
    CAT.[Id] AS CustomAttributeId, ISNULL(CAO.[Text], CAV.[Value]) AS CustomAttributeValue, CA.[IdValueType] AS CustomAttributeIdValueType,  
    H1.[Id] AS IdHierarchyLevel1, H1.[SapId] AS HierarchyLevel1Identifier,  
    H2.[Id] AS IdHierarchyLevel2, H2.[SapId] AS HierarchyLevel2Identifier, P.[Emails]  
  
 FROM  [dbo].[PointOfInterest] P WITH (NOLOCK)  
    LEFT JOIN [dbo].[CustomAttributeValue] CAV WITH (NOLOCK) ON CAV.[IdPointOfInterest] = P.[Id]  
    LEFT JOIN [dbo].[CustomAttributeOption] CAO ON CAV.[IdCustomAttributeOption] = CAO.[Id]  
    LEFT JOIN [dbo].[CustomAttribute] CA ON CAV.[IdCustomAttribute] = CA.[Id] AND CA.[Deleted] = 0  
    LEFT JOIN [dbo].[CustomAttributeTranslated] CAT WITH (NOLOCK) ON CAV.[IdCustomAttribute] = CAT.[Id] AND CAT.[Deleted] = 0  
    LEFT JOIN [dbo].[POIHierarchyLevel1] H1 WITH (NOLOCK) ON H1.[Id] = P.[GrandfatherId]  
    LEFT JOIN [dbo].[POIHierarchyLevel2] H2 WITH (NOLOCK) ON H2.[Id] = P.[FatherId]  
  
 WHERE  P.[Deleted] = 0 AND  
    ((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))  
   
 GROUP BY P.[Id], P.[Name], P.[Address], P.[Identifier], P.[Latitude], P.[Longitude], P.[Radius], P.[MinElapsedTimeForVisit],   
    P.[IdDepartment], P.[NFCTagId], P.[ContactName], P.[ContactPhoneNumber],  
    CAT.[Id], CAT.[Name], ISNULL(CAO.[Text], CAV.[Value]), CA.[IdValueType], H1.[Id], H1.[SapId], H2.[Id], H2.[SapId], P.[Emails]  
  
 ORDER BY P.[Id]  
END
