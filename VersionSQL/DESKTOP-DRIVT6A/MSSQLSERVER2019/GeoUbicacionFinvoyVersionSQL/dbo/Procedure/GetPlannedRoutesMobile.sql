/****** Object:  Procedure [dbo].[GetPlannedRoutesMobile]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPlannedRoutesMobile]  
(  
 @IdPersonOfInterest [sys].[int]   
)  
AS  
BEGIN  
 DECLARE @SystemToday [sys].[datetime]  
 SET @SystemToday = DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0)  
  
 DECLARE @PersonOfInterestType [sys].[CHAR](1) = (SELECT TOP 1 [Type] FROM [dbo].PersonOfInterest WITH (NOLOCK) WHERE [Id] = @IdPersonOfInterest)  
  
 ;WITH PersonRoutesDetail([Id], [RouteDate], [RouteDateSystem], [IdRoutePointOfInterest], [NoVisited], [IsPriority]) AS  
 (  
  SELECT RD.[Id], RD.[RouteDate], Tzdb.FromUtc(RD.[RouteDate]) AS RouteDateSystem, RD.[IdRoutePointOfInterest], RD.[NoVisited], RD.[IsPriority]
  FROM [dbo].[RouteDetail] RD WITH (NOLOCK)  
  WHERE RD.[Disabled] = 0  
 )  
  
 SELECT  RD.[Id], RP.[IdPointOfInterest],RD.[RouteDate], RP.[Comment], RD.[IdRoutePointOfInterest], RD.[NoVisited],  
    POI.[Name] AS PointOfInterestName, POI.[Address] AS PointOfInterestAddress, POI.[Radius] AS PointOfInterestRadius,  
    POI.[Latitude] AS PointOfInterestLatitude, POI.Longitude AS PointOfInterestLongitude,   
    POI.[Identifier] AS PointOfInterestIdentifier,POI.[ContactName], POI.[ContactPhoneNumber],  
    POI.[NFCTagId] AS PointOfInterestNFCTagId, IIF(POI.[Image] IS NULL, IIF(POI.[ImageUrl] IS NULL, 0, 1), 1) AS PointOfInterestHasImage,  
    CAT.[Name] AS CustomAttributeName, ISNULL(CAO.[Text], CAV.[Value]) AS CustomAttributeValue, CAV.[IdCustomAttributeOption], CAT.[IdValueType] AS CustomAttributeType,  
    CAT.[Id] CustomerAttributeId, CAG.Id as IdCustomAttributeGroup,  
    POI1.[Id] AS HierarchyLevel1Id, POI1.[Name] AS HierarchyLevel1Name,  
    POI2.[Id] AS HierarchyLevel2Id, POI2.[Name] AS HierarchyLevel2Name, D.[Id] AS DepartmentId,  
    D.[Name] AS DepartmentName, POI.[Emails] AS PointOfInterestEmails,  
    RD.[IsPriority]
 FROM  PersonRoutesDetail RD WITH (NOLOCK)  
    INNER JOIN [dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[Id] = RD.[IdRoutePointOfInterest]  
    INNER JOIN [dbo].[RouteGroup] RG WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup]  
    INNER JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK) ON P.[Id] = RG.[IdPersonOfInterest]  
    INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON  POI.[Id] = RP.[IdPointOfInterest]  
    LEFT JOIN [dbo].[CustomAttributeValue] CAV WITH (NOLOCK) ON CAV.[IdPointOfInterest] = POI.[Id]  
    LEFT JOIN [dbo].[CustomAttributeTranslated] CAT WITH (NOLOCK) ON CAV.[IdCustomAttribute] = CAT.[Id] AND CAT.[Deleted] = 0  
	left outer join [dbo].[CustomAttributeOption] CAO with(nolock) on CAV.IdCustomAttributeOption = CAO.Id
    LEFT JOIN [dbo].[CustomAttributeGroupCustomAttribute] CAGA WITH (NOLOCK) ON CAT.Id = CAGA.IdCustomAttribute  
    LEFT JOIN [dbo].[CustomAttributeGroup] CAG WITH (NOLOCK) ON CAGA.IdCustomAttributeGroup = CAG.Id AND CAG.[Deleted] = 0  
    LEFT JOIN [dbo].[CustomAttributeGroupPersonType] CAGPT WITH (NOLOCK) ON CAG.Id = CAGPT.IdCustomAttributeGroup AND CAGPT.PersonOfInterestType = @PersonOfInterestType  
    LEFT JOIN [dbo].[POIHierarchyLevel1] POI1 WITH (NOLOCK) ON POI1.[Id] = POI.[GrandfatherId]  
    LEFT JOIN [dbo].[POIHierarchyLevel2] POI2 WITH (NOLOCK) ON POI2.[Id] = POI.[FatherId]  
    LEFT JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[Id] = POI.[IdDepartment]  
   
 WHERE   RG.[IdPersonOfInterest] = @IdPersonOfInterest   
    AND POI.[Deleted] = 0  
    AND RP.[Deleted] = 0 AND P.[Deleted] = 0  
    AND RD.[RouteDateSystem] >= @SystemToday AND RD.[RouteDateSystem] < DATEADD(DAY, 1, @SystemToday)  
    --AND (CAV.Id IS NULL OR (CAV.Id IS NOT NULL AND CAT.Id IS NOT NULL AND CAGPT.IdCustomAttributeGroup IS NOT NULL))  
   
 ORDER BY RD.[Id], CAT.Id, CAG.Id  
END  
  
-- OLD)  
--BEGIN  
-- DECLARE @PersonOfInterestType [sys].[CHAR](1) = (SELECT TOP 1 [Type] FROM [dbo].PersonOfInterest WITH (NOLOCK) WHERE [Id] = @IdPersonOfInterest)  
  
-- SELECT  RD.[Id], RP.[IdPointOfInterest],RD.[RouteDate], RP.[Comment], RD.[IdRoutePointOfInterest], RD.[NoVisited],  
--    POI.[Name] AS PointOfInterestName, POI.[Address] AS PointOfInterestAddress, POI.[Radius] AS PointOfInterestRadius,  
--    POI.[Latitude] AS PointOfInterestLatitude, POI.Longitude AS PointOfInterestLongitude,   
--    POI.[Identifier] AS PointOfInterestIdentifier,POI.[ContactName], POI.[ContactPhoneNumber],  
--    POI.[NFCTagId] AS PointOfInterestNFCTagId,  
--    CA.[Name] AS CustomAttributeName, CAV.[Value] AS CustomAttributeValue, CA.[IdValueType] AS CustomAttributeType,  
--    CA.[Id] CustomerAttributeId, CAG.Id as IdCustomAttributeGroup,  
--    POI1.[Id] AS HierarchyLevel1Id, POI1.[Name] AS HierarchyLevel1Name,  
--    POI2.[Id] AS HierarchyLevel2Id, POI2.[Name] AS HierarchyLevel2Name, D.[Id] AS DepartmentId,  
--    D.[Name] AS DepartmentName  
   
-- FROM  [dbo].[RouteDetail] RD WITH (NOLOCK)  
--    INNER JOIN [dbo].[RoutePointOfInterest] RP WITH (NOLOCK) ON RP.[Id] = RD.[IdRoutePointOfInterest]  
--    INNER JOIN [dbo].[RouteGroup] RG WITH (NOLOCK) ON RG.[Id] = RP.[IdRouteGroup]  
--    INNER JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK) ON P.[Id] = RG.[IdPersonOfInterest]  
--    INNER JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON  POI.[Id] = RP.[IdPointOfInterest]  
--    LEFT JOIN [dbo].[CustomAttributeValue] CAV WITH (NOLOCK) ON CAV.[IdPointOfInterest] = POI.[Id]  
--    LEFT JOIN [dbo].[CustomAttribute] CA WITH (NOLOCK) ON CAV.[IdCustomAttribute] = CA.[Id] AND CA.[Deleted] = 0  
--    LEFT JOIN [dbo].[CustomAttributeGroupCustomAttribute] CAGA WITH (NOLOCK) ON CA.Id = CAGA.IdCustomAttribute  
--    LEFT JOIN [dbo].[CustomAttributeGroup] CAG WITH (NOLOCK) ON CAGA.IdCustomAttributeGroup = CAG.Id AND CAG.[Deleted] = 0  
--    LEFT JOIN [dbo].[CustomAttributeGroupPersonType] CAGPT WITH (NOLOCK) ON CAG.Id = CAGPT.IdCustomAttributeGroup AND CAGPT.PersonOfInterestType = @PersonOfInterestType  
--    LEFT JOIN [dbo].[POIHierarchyLevel1] POI1 WITH (NOLOCK) ON POI1.[Id] = POI.[GrandfatherId]  
--    LEFT JOIN [dbo].[POIHierarchyLevel2] POI2 WITH (NOLOCK) ON POI2.[Id] = POI.[FatherId]  
--    LEFT JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[Id] = POI.[IdDepartment]  
   
-- WHERE   Tzdb.AreSameSystemDates(RD.[RouteDate], GETUTCDATE()) = 1  
--    AND RG.[IdPersonOfInterest] = @IdPersonOfInterest   
--    AND RD.[Disabled] = 0 AND POI.[Deleted] = 0  
--    AND RP.[Deleted] = 0 AND P.[Deleted] = 0  
--    --AND (CAV.Id IS NULL OR (CAV.Id IS NOT NULL AND CA.Id IS NOT NULL AND CAGPT.IdCustomAttributeGroup IS NOT NULL))  
   
-- ORDER BY RD.[Id], CA.Id, CAG.Id  
--END
