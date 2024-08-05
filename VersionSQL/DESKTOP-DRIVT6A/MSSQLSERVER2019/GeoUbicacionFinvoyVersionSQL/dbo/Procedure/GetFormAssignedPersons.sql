/****** Object:  Procedure [dbo].[GetFormAssignedPersons]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================        
-- Author:  <Author,,Name>        
-- Create date: <Create Date,,>        
-- Description: <Description,,>        
-- =============================================        
CREATE PROCEDURE [dbo].[GetFormAssignedPersons]        
  @IdForm int        
 ,@IdUser int = NULL        
 ,@DateFrom [sys].[datetime] = NULL        
 ,@DateTo [sys].[datetime] = NULL         
 ,@Type [sys].[int] = 0        
 ,@IdDynamic [sys].[int] = 0        
AS        
BEGIN        
         
 IF @Type = 0        
 BEGIN        
  SELECT P.[Id] AS PersonOfInterestId        
    ,P.[Name] AS PersonOfInterestName        
    ,P.[LastName] AS PersonOfInterestLastName        
    ,(CASE WHEN COUNT(C.Id) > 0 THEN 1 ELSE 0 END) AS CompletedAnAssignedPoint        
         
  FROM [dbo].[AssignedForm] A WITH(NOLOCK)          
  JOIN [dbo].[PersonOfInterest] P WITH(NOLOCK) ON P.Id = A.IdPersonOfInterest        
  LEFT OUTER JOIN [dbo].[CompletedForm] C WITH(NOLOCK) ON C.IdForm = A.IdForm AND C.IdPersonOfInterest = P.Id AND (C.[Date] >= @DateFrom AND C.[Date] <= @DateTo)        
  WHERE A.[IdForm] = @IdForm        
   AND A.[Deleted] = 0 AND P.[Deleted] = 0        
   AND ((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(P.[Id], @IdUser) = 1))        
         AND ((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUser) = 1))        
  GROUP BY P.Id, P.[Name], P.LastName        
 END        
 ELSE IF @Type = 1        
 BEGIN        
  SELECT PEOI.[Id] AS PersonOfInterestId        
    ,PEOI.[Name] AS PersonOfInterestName        
    ,PEOI.[LastName] AS PersonOfInterestLastName        
  , (CASE WHEN (SELECT COUNT([Id]) FROM [CompletedForm] CF WITH (NOLOCK) WHERE CF.[IdForm] = FP.[IdForm] AND CF.[IdPersonOfInterest] = PEOI.[Id] AND(CF.[Date] >= @DateFrom AND CF.[Date] <= @DateTo)) > 0 THEN 1 ELSE 0 END) AS CompletedAnAssignedPoint        
  FROM [Dynamic] D WITH (NOLOCK)        
  INNER JOIN [FormPlus] FP WITH (NOLOCK) ON D.[IdFormPlus] = FP.[Id]        
  LEFT JOIN [DynamicPersonOfInterest] DPEOI WITH (NOLOCK) ON D.[Id] = DPEOI.[IdDynamic]        
  LEFT JOIN [PersonOfInterest] PEOI WITH (NOLOCK) ON DPEOI.[IdPersonOfInterest] = PEOI.[Id] OR D.[AllPersonOfInterest] = 1        
  WHERE FP.[IdForm] = @IdForm AND D.[Id] = @IdDynamic        
 END        
          
END
