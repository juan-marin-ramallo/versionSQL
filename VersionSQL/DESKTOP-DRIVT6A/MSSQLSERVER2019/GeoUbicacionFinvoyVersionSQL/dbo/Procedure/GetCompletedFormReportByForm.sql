/****** Object:  Procedure [dbo].[GetCompletedFormReportByForm]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:  Diego Cáceres    
-- Create date: 17/10/2014    
-- Description: SP para obtener un reporte de puntos de interés por formulario    
-- =============================================    
CREATE PROCEDURE [dbo].[GetCompletedFormReportByForm]    
      
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
    
 SELECT P.[Id] AS IdPointOfInterest, P.[Name] AS PointOfInterestName,    
   P.[Identifier] AS PointOfInterestIdentifier,     
   COUNT(DISTINCT CF.Id) AS CompletedFormsCount    
 FROM [dbo].[CompletedForm] CF  with(nolock)    
   INNER JOIN [dbo].[PointOfInterest] P ON CF.IdPointOfInterest = P.Id    
   LEFT JOIN [dbo].[PersonOfInterest] S with(nolock) ON S.[Id] = CF.[IdPersonOfInterest]      
   left outer join [dbo].[Answer] A ON CF.Id = A.IdCompletedForm AND a.QuestionType = 'TAG'    
   left outer join [dbo].[AnswerTag] ATA ON A.Id = ATA.IdAnswer              
   LEFT OUTER JOIN [dbo].[DynamicCompletedForm] DCF WITH (NOLOCK) ON CF.[Id] = DCF.[IdCompletedForm]                      
   LEFT OUTER JOIN [dbo].[Dynamic] D WITH (NOLOCK) ON DCF.[IdDynamic] = D.[Id]                      
 WHERE CF.[IdForm] = @FilterIdForm AND    
   (D.[Id] IS NULL OR D.[Id] = @FilterIdDynamic) AND    
   (@FilterDateFrom IS NULL AND @FilterDateTo IS NULL     
    OR (CF.[Date] BETWEEN @FilterDateFrom AND @FilterDateTo)) AND    
   ((@FilterStockersIds IS NULL) OR (D.[AllPersonOfInterest] = 1) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @FilterStockersIds) = 1)) AND    
   ((@FilterPointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](P.[Id], @FilterPointOfInterestIds) = 1)) AND    
   ((@FilterTagIds IS NULL) OR ((@FilterTagIds = '-1' AND ATA.IdAnswer is null) OR (@FilterTagIds <> '-1' AND ATA.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATA.[IdTag], @FilterTagIds) = 1))) AND    
   ((@FilterIdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(P.[Id], @FilterIdUser) = 1)) AND    
   ((@FilterIdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @FilterIdUser) = 1))    
 GROUP BY P.[Id], P.[Name],P.[Identifier]    
END
