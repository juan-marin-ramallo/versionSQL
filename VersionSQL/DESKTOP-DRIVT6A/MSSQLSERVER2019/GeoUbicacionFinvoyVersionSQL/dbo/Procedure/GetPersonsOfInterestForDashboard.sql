/****** Object:  Procedure [dbo].[GetPersonsOfInterestForDashboard]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[GetPersonsOfInterestForDashboard]  
(  
  @Imeis [sys].[varchar](max) = NULL  
 ,@CellPhoneNumbers [sys].[varchar](max) = NULL  
 ,@PersonOfInterestIds [sys].[varchar](max) = NULL  
 ,@ProfilesId [sys].[varchar](max) = NULL  
 ,@IdUser [sys].[int] = NULL  
 ,@IncludeAutomaticVisits [sys].[bit]  
 ,@SearchInput [sys].[varchar](100) = NULL  
 ,@Offset [sys].[int]  
 ,@Step [sys].[int]  
)  
AS  
BEGIN  
 DECLARE @SearchTerm [sys].[varchar](102)  
 SET @SearchTerm = IIF(@SearchInput IS NULL, NULL, '%' + @SearchInput + '%')  
  
 DECLARE @DateFrom [sys].[datetime]  
 DECLARE @DateTo [sys].[datetime]  
  
 SET @DateFrom = Tzdb.ToUtc(DATEADD(DAY, DATEDIFF(DAY, 0, Tzdb.FromUtc(GETUTCDATE())), 0))  
 SET @DateTo = DATEADD(DAY, 1, @DateFrom)  
  
 SELECT  S.[Id], S.[Name], S.[LastName], S.[Identifier], S.[MobilePhoneNumber], S.[MobileIMEI],   
    S.[IdDepartment], S.[Status], S.[Type], S.[Avatar], S.DeviceBrand, S.DeviceModel, S.AndroidVersion,  
    ST.[Description] AS TypeDescription,   
    D.[Name] AS DepartmentName,   
    L.[IdLocation], L.[Date] AS [CurrentLocationDate], L.[BatteryLevel],  
    CU.[UserId] AS IdChatUser,  
    [dbo].GetLastVisitedPointOfInterestName(S.[Id], @IncludeAutomaticVisits) AS [PointOfInterestName],   
    COUNT(C.[Id]) AS CompletedFormsCount  
       
 FROM  [dbo].[AvailablePersonOfInterest] S WITH (NOLOCK)  
    LEFT OUTER JOIN [dbo].[Department] D WITH (NOLOCK) ON D.[Id] = S.[IdDepartment]  
    LEFT OUTER JOIN [dbo].[PersonOfInterestType] ST WITH (NOLOCK) ON ST.[Code] = S.[Type]  
    LEFT OUTER JOIN [dbo].[CurrentLocation] L WITH (NOLOCK) ON S.[Id] = L.[IdPersonOfInterest]  
    --LEFT OUTER JOIN [dbo].[CompletedForm] C WITH (NOLOCK) ON C.[IdPersonOfInterest] = S.[Id] AND Tzdb.AreSameSystemDates(C.[Date], GETUTCDATE()) = 1  
    LEFT OUTER JOIN [dbo].[CompletedForm] C WITH (NOLOCK) ON C.[IdPersonOfInterest] = S.[Id] AND C.[Date] BETWEEN @DateFrom AND @DateTo  
    LEFT OUTER JOIN [dbo].[ChatUser] CU WITH (NOLOCK) ON CU.[IdPersonOfInterest] = S.[Id] AND CU.Deleted = 0  
    
 WHERE  (CASE WHEN @SearchTerm IS NULL THEN 1  
    ELSE  
     (CASE WHEN S.[Name] LIKE @SearchTerm OR S.[LastName] LIKE @SearchTerm OR S.[Identifier] LIKE @SearchTerm OR S.[MobileIMEI] LIKE @SearchTerm THEN 1  
     ELSE  
      (CASE WHEN @SearchTerm LIKE S.[Name] OR @SearchTerm LIKE S.[LastName] OR @SearchTerm LIKE S.[Identifier] OR @SearchTerm LIKE S.[MobileIMEI] THEN 1  
      ELSE 0  
      END)  
     END)  
    END) = 1 AND  
    ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND  
    ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND  
    ((@Imeis IS NULL) OR (dbo.CheckVarcharInList(S.[MobileIMEI], @Imeis) = 1)) AND  
    ((@CellPhoneNumbers IS NULL) OR (dbo.CheckVarcharInList(S.[MobilePhoneNumber], @CellPhoneNumbers) = 1)) AND  
    ((@ProfilesId IS NULL) OR (dbo.CheckVarcharInList(ST.[Code], @ProfilesId) = 1)) AND  
    ((@PersonOfInterestIds IS NULL) OR (dbo.CheckValueInList(S.[Id], @PersonOfInterestIds) = 1))    
   
 GROUP BY S.[Id], S.[Name], S.[LastName], S.[Identifier], S.[MobilePhoneNumber], S.[MobileIMEI],  
    S.[IdDepartment], S.[Status], S.[Type], S.[Avatar], S.DeviceBrand, S.DeviceModel, S.AndroidVersion,  
    ST.[Description],   
    D.[Name],   
    L.[IdLocation], L.[Date], L.[BatteryLevel],  
    CU.[UserId]  
  
 ORDER BY L.[Date] DESC, S.[Name], S.[LastName]  
  
 OFFSET @Offset ROWS  
 FETCH NEXT @Step ROWS ONLY  
  
END
