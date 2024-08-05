/****** Object:  Procedure [dbo].[GetAssignedTotalsByForm]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- =============================================      
CREATE PROCEDURE [dbo].[GetAssignedTotalsByForm]      
 @FormId int      
 --,@PointOfInterestIds [sys].[varchar](MAX) = NULL      
 --,@PersonOfInterestIds [sys].[varchar](MAX) = NULL      
AS      
BEGIN      
 DECLARE @FormIdLocal [sys].[int]      
 SET @FormIdLocal = @FormId      
       
 BEGIN      
  IF EXISTS (SELECT 1 FROM [dbo].[Form] WHERE [Id] = @FormIdLocal AND [IsFormPlus] = 0)    
  BEGIN    
    SELECT COUNT(DISTINCT(A.[IdPointOfInterest])) AS TotalAssignedPoints,      
      COUNT(DISTINCT(A.[IdPersonOfInterest])) AS TotalAssignedPersons      
          
    FROM [dbo].[AssignedForm] A WITH (NOLOCK)      
          
    WHERE A.[IdForm] = @FormIdLocal AND A.[Deleted] = 0 --AND    
                  --((@PointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](A.[IdPointOfInterest], @PointOfInterestIds) = 1)) and    
                  --((@PersonOfInterestIds IS NULL) OR (dbo.[CheckValueInList](A.[IdPersonOfInterest], @PersonOfInterestIds) = 1))    
  END    
  ELSE BEGIN    
    SELECT D.[Id] AS [IdDynamic], FP.[IdForm]    
    , (SELECT COUNT([Id]) FROM [DynamicProductPointOfInterest] WHERE [IdDynamic] = D.[Id]) AS TotalAssignedPoints    
    , CASE WHEN D.[AllPersonOfInterest] = 1 THEN (SELECT COUNT(PEOI.[Id]) FROM [PersonOfInterest] PEOI WITH (NOLOCK)) ELSE (SELECT COUNT(DPEOI.[IdDynamic]) FROM [DynamicPersonOfInterest] DPEOI WITH (NOLOCK) WHERE [IdDynamic] = D.[Id]) END AS TotalAssignedPersons    
    FROM [Dynamic] D WITH (NOLOCK)    
    INNER JOIN [FormPlus] FP WITH (NOLOCK) ON D.[IdFormPlus] = FP.[Id]    
    WHERE Fp.[IdForm] = @FormId
  END    
 END      
      
END
