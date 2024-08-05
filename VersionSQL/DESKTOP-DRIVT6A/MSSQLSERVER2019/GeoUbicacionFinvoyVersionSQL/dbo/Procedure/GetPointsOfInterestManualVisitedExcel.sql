/****** Object:  Procedure [dbo].[GetPointsOfInterestManualVisitedExcel]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetPointsOfInterestManualVisitedExcel]  
(  
  @DateFrom [sys].[datetime]  
 ,@DateTo [sys].[datetime]  
 ,@IdDepartments [sys].[varchar](max) = NULL  
 ,@IdPersonsOfInterest [sys].[varchar](max) = NULL  
 ,@IdPointsOfInterest [sys].[varchar](max) = NULL   
 ,@IdUser [sys].[int] = NULL  
)  
AS  
BEGIN  
 DECLARE @AllowCheckOutManualNoLimits VARCHAR = (SELECT [value] FROM [dbo].[configuration] WHERE ID = 4066)

 ;WITH vPointsManualVisited AS  
 (  
  SELECT POIMV.[Id], POIMV.[CheckInDate], POIMV.[CheckOutDate], POIMV.[CheckOutPointOfInterestId], POIMV.[CheckOutLatitude], POIMV.[CheckOutLongitude],  
    POIMV.[IdPointOfInterest], POIMV.[IdPersonOfInterest], POIMV.[ElapsedTime],  
    POIMV.[Edited], POIMV.[CheckInImageName], POIMV.[CheckInImageUrl], POIMV.[CheckOutImageName], POIMV.[CheckOutImageUrl],  
    POID.[ConfirmedVisit]  
  FROM [dbo].[PointOfInterestManualVisited] POIMV WITH (NOLOCK)  
    LEFT OUTER JOIN [dbo].PointsOfInterestActivityDoneSimplified(@DateFrom, @DateTo, @IdDepartments, NULL, @IdPersonsOfInterest,   
     @IdPointsOfInterest, @IdUser) POID ON POID.[IdPersonOfInterest] = POIMV.[IdPersonOfInterest]  
      AND POID.[IdPointOfInterest] = POIMV.[IdPointOfInterest]  
      AND POID.[ActionDate] BETWEEN POIMV.[CheckInDate] AND POIMV.[CheckOutDate]  
  WHERE POIMV.[DeletedByNotVisited] = 0 AND   
    ((POIMV.[CheckOutDate] IS NULL AND POIMV.[CheckInDate] >= @DateFrom AND POIMV.[CheckInDate] <= @DateTo)   
     OR (POIMV.[CheckInDate] BETWEEN @DateFrom AND @DateTo)   
     OR (POIMV.[CheckOutDate] BETWEEN @DateFrom AND @DateTo))  
 )  
 ,vPoints AS  
 (  
  SELECT P.[Id], P.[Name], P.[Latitude], P.[Longitude], P.[Identifier], P.[Address], P.[IdDepartment], P.[FatherId], P.[GrandfatherId],  
    P.[ContactName], P.[ContactPhoneNumber]  
  FROM [dbo].[PointOfInterest] P WITH (NOLOCK)  
  WHERE ((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1) AND  
     (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))  
 )  
 ,vPersons AS  
 (  
  SELECT S.[Id], S.[Name], S.[LastName], S.[MobileIMEI], S.[MobilePhoneNumber], S.[Identifier]  
  FROM [dbo].[PersonOfInterest] S WITH (NOLOCK)  
  WHERE ((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND  
    ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1) AND  
     (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1))  
 )  
  
 SELECT POIMV.[Id] as IdPointOfInterestManualVisited, S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName,   
   S.[LastName] AS PersonOfInterestLastName, POIMV.[CheckInDate],  
   POIMV.[CheckOutDate], POIMV.[IdPointOfInterest], P.[Name] AS PointOfInterestName, [ElapsedTime],  
   P.[Latitude], P.[Longitude], P.[Identifier] AS PointOfInterestIdentifier, S.[MobileIMEI] AS PersonOfInterestIMEI,  
   S.[MobilePhoneNumber] AS PersonOfInterestMobilePhoneNumber, S.[Identifier] AS PersonOfInterestIdentifier,  
   DEP.[Id] AS DepartmentId, DEP.[Name] AS DepartmentName, P.[Address] AS PointOfInterestAddress,  
   POI1.[Id] AS HierarchyLevel1Id, POI1.[Name] AS HierarchyLevel1Name,  
   POI2.[Id] AS HierarchyLevel2Id, POI2.[Name] AS HierarchyLevel2Name, POIMV.[Edited],  
   P.[ContactName] AS PointOfInterestContactName, P.[ContactPhoneNumber] AS PointOfInterestContactPhoneNumber,  
   CAT.[Name] AS CustomAttributeName, ISNULL(CAO.[Text], CAV.[Value]) AS CustomAttributeValue, CAV.[IdCustomAttributeOption], CAT.[Id] AS CustomAttributeId,  
   POIMV.[ConfirmedVisit] AS ConfirmedVisit, POIMV.CheckOutLatitude, POIMV.CheckOutLongitude,  
   CASE WHEN @AllowCheckOutManualNoLimits = 0 THEN NULL ELSE POut.[Id] END AS CheckOutIdPointOfInterest,
   CASE WHEN @AllowCheckOutManualNoLimits = 0 THEN NULL ELSE POut.[Name] END AS CheckOutPointOfInterestName,
   CASE WHEN @AllowCheckOutManualNoLimits = 0 THEN NULL ELSE POut.Identifier END AS CheckOutPointOfInterestIdentifier,
   POIMV.[CheckInImageName], POIMV.[CheckInImageUrl], POIMV.[CheckOutImageName], POIMV.[CheckOutImageUrl]  
 FROM vPointsManualVisited POIMV WITH (NOLOCK)  
   INNER JOIN vPoints P WITH (NOLOCK) ON P.[Id] = POIMV.[IdPointOfInterest]  
   INNER JOIN vPersons S WITH (NOLOCK) ON S.[Id] = POIMV.[IdPersonOfInterest]  
   LEFT OUTER JOIN [dbo].[Department] DEP WITH (NOLOCK) ON DEP.[Id] = P.[IdDepartment]  
   LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] POI1 WITH (NOLOCK) ON POI1.[Id] = P.[GrandfatherId]  
   LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] POI2 WITH (NOLOCK) ON POI2.[Id] = P.[FatherId]  
   LEFT OUTER JOIN [dbo].[PointOfInterest] POut WITH (NOLOCK) ON POut.[Id] = POIMV.[CheckOutPointOfInterestId]  
   LEFT JOIN [dbo].[CustomAttributeValue] CAV WITH (NOLOCK) ON CAV.[IdPointOfInterest] = P.[Id]  
   LEFT JOIN [dbo].[CustomAttributeTranslated] CAT WITH (NOLOCK) ON CAV.[IdCustomAttribute] = CAT.[Id] AND CAT.[Deleted] = 0   
   LEFT OUTER JOIN dbo.CustomAttributeOption CAO with(nolock) on CAV.IdCustomAttributeOption = CAO.Id  
 GROUP   
 BY  POIMV.[Id], S.[Id], S.[Name], S.[LastName], POIMV.[CheckInDate],  
   POIMV.[CheckOutDate], POIMV.[IdPointOfInterest], P.[Name], [ElapsedTime], P.[Latitude], P.[Longitude], P.[Identifier],   
   S.[MobileIMEI], S.[MobilePhoneNumber], S.[Identifier], DEP.[Id], DEP.[Name], P.[Address],  
   P.[ContactName],P.[ContactPhoneNumber],  
   POI1.[Id], POI1.[Name], POI2.[Id], POI2.[Name] , POIMV.[Edited], CAT.[Name],  
   ISNULL(CAO.[Text], CAV.[Value]), CAV.[IdCustomAttributeOption], CAT.[Id], POIMV.CheckOutLatitude, POIMV.CheckOutLongitude,  
   POIMV.[ConfirmedVisit], POut.[Id], POut.[Name], POut.Identifier,  
   POIMV.[CheckInImageName], POIMV.[CheckInImageUrl], POIMV.[CheckOutImageName], POIMV.[CheckOutImageUrl]  
 ORDER BY POIMV.[CheckInDate] ASC, POIMV.[CheckOutDate] ASC  
END
