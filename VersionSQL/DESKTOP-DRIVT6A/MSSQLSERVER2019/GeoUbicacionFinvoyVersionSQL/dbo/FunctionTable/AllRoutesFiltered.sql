/****** Object:  TableFunction [dbo].[AllRoutesFiltered]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Federico Sobral  
-- Create date: 23/08/2016  
-- Description: <Description,,>  
-- =============================================  
CREATE FUNCTION [dbo].[AllRoutesFiltered]  
(   
  @DateFrom [sys].[datetime]  
 ,@DateTo [sys].[datetime]  
 ,@IdDepartments [sys].[varchar](max) = NULL  
 ,@Types [sys].[varchar](max) = NULL  
 ,@IdPersonsOfInterest [sys].[varchar](max) = NULL  
 ,@IdPointsOfInterest [sys].[varchar](max) = NULL   
 ,@IdUser [sys].[int] = NULL  
 ,@IncludeDeleted [sys].[bit] = 1  
)  
RETURNS TABLE   
AS  
RETURN   
(  
 SELECT RP.[Id] as IdRoute, RD.[RouteDate], S.[Id] AS IdPersonOfInterest, S.[Name] AS PersonOfInterestName,   
   S.[LastName] AS PersonOfInterestLastName, S.[Identifier] AS PersonOfInterestIdentifier,   
   [IdPointOfInterest], P.[Name] AS PointOfInterestName, P.[Identifier] AS PointOfInterestIdentifier,  
   P.[Address] as [PointOfInterestAddress], P.Latitude AS [PointOfInterestLatitude], P.Longitude as [PointOfInterestLongitude],  
   P.Radius AS [PointOfInterestRadius], P.MinElapsedTimeForVisit as [PointOfInterestMinElapsedTimeForVisit],  
   RD.[Id] AS IdRouteDetail,   
   LTRIM(RTRIM(ISNULL(RD.[WebNoVisitComment],'') + ' ' + ISNULL(RD.NoVisitedApprovedComment,''))) AS NoVisitComment,  
   RD.[FromHour] AS RouteFromHour, RD.[ToHour] AS RouteToHour,  
   WAP.[WorkActivityTypeId] AS ActivityVisitTypeId, RG.[Id] as IdRouteGroup, RG.[Name] as RouteGroupName  
  
 FROM [dbo].[RouteGroup] RG with(nolock)  
   INNER JOIN [dbo].[RoutePointOfInterest] RP with(nolock) ON RP.[IdRouteGroup] = RG.[Id]   
   LEFT JOIN [dbo].[RouteDetail] RD with(nolock) ON RP.[Id] = RD.[IdRoutePointOfInterest]  
   LEFT JOIN [dbo].[PointOfInterest] P with(nolock) ON P.[Id] = RP.[IdPointOfInterest]     
   LEFT JOIN [dbo].[PersonOfInterest] S with(nolock) ON S.[Id] = RG.[IdPersonOfInterest]  
   LEFT JOIN [dbo].[WorkActivityPlanned] WAP WITH(NOLOCK) ON WAP.[RoutePointOfInterestId] = RP.[Id]  
  
 WHERE RD.[RouteDate] BETWEEN @DateFrom AND @DateTo AND  
   ((@IdDepartments IS NULL) OR (S.[IdDepartment] IS NULL) OR (dbo.CheckValueInList(S.[IdDepartment], @IdDepartments) = 1)) AND  
   ((@Types IS NULL) OR (dbo.CheckCharValueInList(S.[Type], @Types) = 1)) AND  
   ((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(S.[Id], @IdPersonsOfInterest) = 1)) AND  
   ((@IdPointsOfInterest IS NULL) OR (dbo.CheckValueInList(P.[Id], @IdPointsOfInterest) = 1)) AND     
   ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND  
   ((@IdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @IdUser) = 1)) AND  
   ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND  
   ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))   
   AND RD.[Disabled] = 0 --AND R.Deleted = 'False' AND P.Deleted = 0 AND S.Deleted = 0  
   AND (@IncludeDeleted = 1 OR RG.[Deleted] = 0)
   
 GROUP BY  RP.[Id], RD.[RouteDate], S.[Id], S.[Name], S.[LastName], S.[Identifier],   
           [IdPointOfInterest], P.[Name], P.[Identifier], P.[Address], P.Latitude, P.Longitude,  
     P.Radius, P.MinElapsedTimeForVisit, RD.[Id] , RD.[WebNoVisitComment],  
     RD.[FromHour], RD.[ToHour], WAP.[WorkActivityTypeId], RG.[Id], RG.[Name],RD.NoVisitedApprovedComment  
  
)
