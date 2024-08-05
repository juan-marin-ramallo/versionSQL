/****** Object:  Procedure [dbo].[GetCompletedFormPersonReportByForm]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE [dbo].[GetCompletedFormPersonReportByForm]     
  @IdForm [sys].[int]    
 ,@DateFrom [sys].[datetime]    
 ,@DateTo [sys].[DATETIME]    
    ,@PointOfInterestIds [sys].[varchar](MAX) = NULL    
 ,@StockersIds [sys].[varchar](MAX) = NULL    
 ,@TagIds [sys].[varchar](MAX) = NULL    
 ,@IdUser [sys].[INT] = NULL    
 ,@IdDynamic [sys].[INT] = NULL    
AS    
BEGIN    
    DECLARE @FilterIdForm [sys].[int] = @IdForm    
 DECLARE @FilterDateFrom [sys].[datetime] = @DateFrom    
 DECLARE @FilterDateTo [sys].[DATETIME] = @DateTo    
    DECLARE @FilterPointOfInterestIds [sys].[varchar](MAX) = @PointOfInterestIds    
 DECLARE @FilterStockersIds [sys].[varchar](MAX) = @StockersIds    
 DECLARE @FilterTagIds [sys].[varchar](MAX) = @TagIds    
 DECLARE @FilterIdUser [sys].[INT] = @IdUser    
 DECLARE @FilterIdDynamic [sys].[INT] = @IdDynamic    
    
 SELECT P.[Id] AS IdPersonOfInterest, P.[Name] AS PersonOfInterestName,     
   P.[LastName] AS PersonOfInterestLastName, P.[Identifier] AS PersonOfInterestIdentifier,     
   COUNT(DISTINCT CF.Id) AS CompletedFormsCount    
     
 FROM [dbo].[PersonOfInterest] P     
    INNER JOIN [dbo].[CompletedForm] CF with(nolock) ON P.[Id] = CF.[IdPersonOfInterest]     
    left outer join [dbo].[Answer] A ON CF.Id = A.IdCompletedForm AND a.QuestionType = 'TAG'    
    left outer join [dbo].[AnswerTag] ATA ON A.Id = ATA.IdAnswer    
    LEFT OUTER JOIN [dbo].[DynamicCompletedForm] DCF WITH (NOLOCK) ON CF.[Id] = DCF.[IdCompletedForm]                      
    LEFT OUTER JOIN [dbo].[Dynamic] D WITH (NOLOCK) ON DCF.[IdDynamic] = D.[Id]                      
     
 WHERE CF.[IdForm] = @FilterIdForm AND    
   (D.[Id] IS NULL OR D.[Id] = @FilterIdDynamic) AND    
   (@FilterDateFrom IS NULL AND @FilterDateTo IS NULL     
    OR (CF.[Date] BETWEEN @FilterDateFrom AND @FilterDateTo)) AND    
   ((@FilterPointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @FilterPointOfInterestIds) = 1)) AND    
   ((@FilterStockersIds IS NULL) OR (D.[AllPersonOfInterest] = 1) OR (dbo.[CheckValueInList](P.[Id], @FilterStockersIds) = 1)) AND    
   ((@FilterTagIds IS NULL) OR ((@FilterTagIds = '-1' AND ATA.IdAnswer is null) OR (@FilterTagIds <> '-1' AND ATA.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATA.[IdTag], @FilterTagIds) = 1))) AND    
   ((@FilterIdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @FilterIdUser) = 1)) AND    
   ((@FilterIdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @FilterIdUser) = 1))    
     
 GROUP BY P.[Id], P.[Name],P.[Identifier], P.[LastName]    
END
