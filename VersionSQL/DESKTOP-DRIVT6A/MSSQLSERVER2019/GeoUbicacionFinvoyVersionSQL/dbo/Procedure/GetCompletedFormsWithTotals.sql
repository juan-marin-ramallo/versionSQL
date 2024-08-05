/****** Object:  Procedure [dbo].[GetCompletedFormsWithTotals]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================                                
-- Author:  <Author,,Name>                                
-- Create date: <Create Date,,>                                
-- Description: <Description,,>                                
-- =============================================                                
CREATE PROCEDURE [dbo].[GetCompletedFormsWithTotals]                                
  @DateFrom [sys].[datetime]                                
 ,@DateTo [sys].[datetime]                                
 ,@FormIds [sys].[varchar](MAX) = NULL                                
 ,@DynamicIds [sys].[varchar](MAX) = NULL                                
 ,@PointOfInterestIds [sys].[varchar](MAX) = NULL                                
 ,@StockersIds [sys].[varchar](MAX) = NULL                                
 ,@IdUser [sys].[INT] = NULL                                
 ,@CategoryIds [sys].[varchar](max) = NULL                                
 ,@TypeIds [sys].[varchar](max) = NULL                                
 ,@TagIds [sys].[varchar](MAX) = NULL                                
 ,@OutsidePointOfInterest [sys].[bit] = NULL                                
 ,@IdCompanies [sys].[varchar](MAX) = NULL                                
 ,@IsFormPlus [sys].[bit] = 0                                
 ,@ProductIds [sys].[varchar](max) = NULL                                
 ,@ProductCategoryIds [sys].[varchar](max) = NULL                                
 WITH RECOMPILE                                
AS                                
BEGIN                                
 DECLARE @FilterDateFrom [sys].[datetime] = @DateFrom                                
 DECLARE @FilterDateTo [sys].[datetime] = @DateTo                                
 DECLARE @FilterFormIds [sys].[varchar](MAX) = @FormIds                                
 DECLARE @FilterDynamicIds [sys].[varchar](MAX) = @DynamicIds                                
 DECLARE @FilterPointOfInterestIds [sys].[varchar](MAX) = @PointOfInterestIds                                
 DECLARE @FilterStockersIds [sys].[varchar](MAX) = @StockersIds                                
 DECLARE @FilterIdUser [sys].[INT] = @IdUser                                
 DECLARE @FilterCategoryIds [sys].[varchar](max) = @CategoryIds                                
 DECLARE @FilterTypeIds [sys].[varchar](max) = @TypeIds                                
 DECLARE @FilterTagIds [sys].[varchar](MAX) = @TagIds                                
 DECLARE @FilterOutsidePointOfInterest [sys].[bit] = @OutsidePointOfInterest                                
 DECLARE @FilterIdCompanies [sys].[varchar](MAX) = @IdCompanies                                
 DECLARE @FilterIsFormPlus [sys].[bit] = @IsFormPlus                                
 DECLARE @FilterProductIds [sys].[varchar](max) = @ProductIds                                
 DECLARE @FilterProductCategoryIds [sys].[varchar](max) = @ProductCategoryIds                                
          
 SELECT CF.[Id], CF.[IdForm], CF.[IdPersonOfInterest], CF.[IdPointOfInterest],                                
   F.[Name], F.[Date], F.[Deleted], F.[IdUser],                                
   F.[AllPersonOfInterest], F.[AllPointOfInterest],F.[IsWeighted], F.[NonPointOfInterest],                                
   F.[IdFormCategory], FC.[Name] AS FormCategoryName,                                
   F.[IdFormType], PT.[Name] AS FormTypeName, F.[IsFormPlus]                                
 INTO #CompletedForms                                
 FROM [dbo].[CompletedForm] CF WITH (NOLOCK)                                
   INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[Id] = CF.[IdForm]                                
   INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]                                
   LEFT OUTER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]                                
   LEFT OUTER JOIN [dbo].[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]                                
   LEFT OUTER JOIN [dbo].[Parameter] PT WITH (NOLOCK) ON PT.[Id] = F.[IdFormType]                                
   LEFT OUTER JOIN [dbo].[DynamicCompletedForm] DCF WITH (NOLOCK) ON CF.[Id] = DCF.[IdCompletedForm]                                
   LEFT OUTER JOIN [dbo].[Dynamic] D WITH (NOLOCK) ON DCF.[IdDynamic] = D.[Id]                                
   LEFT OUTER JOIN [dbo].[DynamicProductPointOfInterest] DPPOI WITH (NOLOCK) ON P.[Id] = DPPOI.[IdPointOfInterest] AND D.[Id] = DPPOI.[IdDynamic]                                
   LEFT OUTER JOIN [dbo].[Product] Pro WITH (NOLOCK) ON DPPOI.[IdProduct] = Pro.[Id]                  
   LEFT OUTER JOIN [dbo].[ProductCategoryList] PCL WITH (NOLOCK) ON Pro.[Id] = PCL.[IdProduct]                  
   LEFT OUTER JOIN [dbo].[ProductBrand] PB WITH (NOLOCK) ON Pro.[IdProductBrand] = PB.[Id]                
 WHERE ((CF.[Date] >= @FilterDateFrom AND CF.[Date] <= @FilterDateTo) OR                                
    (CF.[StartDate] >= @FilterDateFrom AND CF.[StartDate] <= @FilterDateTo)) AND                                
    ((@FilterFormIds IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FilterFormIds) = 1)) AND                                
    ((@FilterCategoryIds IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @FilterCategoryIds) = 1)) AND                                
    ((@FilterTypeIds IS NULL) OR (dbo.[CheckValueInList](F.[IdFormType], @FilterTypeIds) = 1)) AND                                
    ((@FilterPointOfInterestIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @FilterPointOfInterestIds) = 1)) AND                                
    ((@FilterProductIds IS NULL) OR (dbo.[CheckValueInList](Pro.[Id], @FilterProductIds) = 1)) AND                                
    ((@FilterProductCategoryIds IS NULL) OR (dbo.[CheckValueInList](PCL.[Id], @FilterProductCategoryIds) = 1)) AND                                
    (@FilterOutsidePointOfInterest IS NULL OR (@FilterOutsidePointOfInterest = 1 AND F.[NonPointOfInterest] = 1)) AND                                
    ((@FilterStockersIds IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @FilterStockersIds) = 1)) AND                                
    ((@FilterIdCompanies IS NULL) OR (dbo.[CheckValueInList](PB.[IdCompany], @FilterIdCompanies) = 1)) AND                                
    ((@FilterIdUser IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @FilterIdUser) = 1)) AND                                
    ((@FilterIdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @FilterIdUser) = 1)) AND                                
    ((@FilterIdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @FilterIdUser) = 1)) AND                                
    ((@FilterIdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @FilterIdUser) = 1))                                
    AND ((@FilterIdUser IS NULL) OR (dbo.CheckUserInFormCompanies(F.[IdCompany], @FilterIdUser) = 1))                                
    AND (F.IsFormPlus = @FilterIsFormPlus)            
          
 SELECT AF.[IdForm], AF.[IdPointOfInterest], AF.[IdPersonOfInterest]                      
 INTO #AssignedForms                                
 FROM [dbo].[AssignedForm] AF WITH (NOLOCK)                                
   inner join #CompletedForms CF on AF.IdForm = CF.IdForm                                
 WHERE AF.[Deleted] = 0                                
 GROUP BY AF.[IdForm], AF.[IdPointOfInterest], AF.[IdPersonOfInterest]                                
                                
 DECLARE @Command  varchar(MAX)              
 CREATE TABLE #FormsTotals              
 (              
  IdDynamic INT,            
  IdForm INT,              
  TotalAssignedPoints INT,              
  TotalAssignedPersons INT              
 )              
                                
 IF @FilterIsFormPlus = 0              
 BEGIN         
  SET @Command = 'INSERT INTO  #FormsTotals                                  
  SELECT  0 AS [IdDynamic], [IdForm], COUNT(DISTINCT [IdPointOfInterest]) AS TotalAssignedPoints, COUNT(DISTINCT [IdPersonOfInterest]) AS TotalAssignedPersons                                
  FROM  #AssignedForms                                
  GROUP BY [IdForm]'                                
 END                                
 ELSE              
 BEGIN              
  SET @Command = 'INSERT INTO  #FormsTotals                                
  SELECT D.[Id] AS [IdDynamic], FP.[IdForm]                                
  , (SELECT COUNT([Id]) FROM [DynamicProductPointOfInterest] WHERE [IdDynamic] = D.[Id]) AS TotalAssignedPoints                                
  , CASE WHEN D.[AllPersonOfInterest] = 1 THEN (SELECT COUNT(PEOI.[Id]) FROM [PersonOfInterest] PEOI WITH (NOLOCK)) ELSE (SELECT COUNT(DPEOI.[IdDynamic]) FROM [DynamicPersonOfInterest] DPEOI WITH (NOLOCK) WHERE [IdDynamic] = D.[Id]) END AS TotalAssignedPersons                                
  FROM [Dynamic] D WITH (NOLOCK)                                
  INNER JOIN [FormPlus] FP WITH (NOLOCK) ON D.[IdFormPlus] = FP.[Id]'                                
 END              
 EXECUTE (@Command)              
                                
 SELECT  CF.[IdForm] as [Id], CF.[Name], CF.[Date], CF.[Deleted],                                
    CF.[AllPersonOfInterest], CF.[AllPointOfInterest], CF.[IsWeighted], CF.[NonPointOfInterest],                                
   CF.[IdFormCategory], CF.FormCategoryName,                                
    CF.[IdFormType], CF.FormTypeName,                                
    COUNT(DISTINCT(CF.[IdPointOfInterest])) AS CompletedPoints,                                
    COUNT(DISTINCT(CF.[IdPersonOfInterest])) AS CompletedPersons, 0 AS OutsidePointOfInterest,                                
    FT.TotalAssignedPoints,                                
    FT.TotalAssignedPersons,                                
    CF.IsFormPlus,                                
    D.[Id] AS DynamicId,                                
    D.[Name] AS DynamicName                                
                                 
 FROM  [dbo].[User] U WITH (NOLOCK)                                
    INNER JOIN #CompletedForms CF WITH (NOLOCK) ON CF.[IdUser] = U.[Id]                                
    INNER JOIN #FormsTotals FT ON FT.[IdForm] = CF.[IdForm]                                
    left outer join [dbo].[Answer] A ON CF.Id = A.IdCompletedForm AND a.QuestionType = 'TAG'                                
    left outer join [dbo].[AnswerTag] ATA ON A.Id = ATA.IdAnswer                                
   LEFT OUTER JOIN [dbo].[DynamicCompletedForm] DCF WITH (NOLOCK) ON CF.[Id] = DCF.[IdCompletedForm]                                
   LEFT OUTER JOIN [dbo].[Dynamic] D WITH (NOLOCK) ON DCF.[IdDynamic] = D.[Id]                                
 WHERE  ((@FilterTagIds IS NULL) OR ((@FilterTagIds = '-1' AND ATA.IdAnswer is null) OR (@FilterTagIds <> '-1' AND ATA.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATA.[IdTag], @FilterTagIds) = 1)))                                
    AND ((@FilterDynamicIds IS NULL) OR (dbo.[CheckValueInList](D.[Id], @FilterDynamicIds) = 1))                                
    AND (@FilterIsFormPlus = 0 OR FT.[IdDynamic] = D.[Id])                                
                                 
 GROUP BY CF.[IdForm], CF.[Name], CF.[Date], CF.[Deleted],                                
    CF.[AllPersonOfInterest], CF.[AllPointOfInterest], CF.[IsWeighted], CF.[NonPointOfInterest],                                
    CF.[IdFormCategory], CF.FormCategoryName,                                
    CF.[IdFormType], CF.FormTypeName,                                
    FT.TotalAssignedPoints,                                
    FT.TotalAssignedPersons,                                
    CF.IsFormPlus,                              
    D.[Id],                              
    D.[Name]                      
                                 
 ORDER BY CF.[Date] desc                                
                                 
 DROP TABLE #AssignedForms                                
 DROP TABLE #CompletedForms                                
 DROP TABLE #FormsTotals                                 
 DROP TABLE #IdFormsWithProduct                                 
                                
END                                
                                
-- OLD)                                
--BEGIN                                
                                
-- DECLARE @DateFromTruncated [sys].[datetime]                                
-- DECLARE @DateToTruncated [sys].[datetime]                                
-- DECLARE @FormIdsLocal [sys].[varchar](MAX)                                
-- DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX)                                
-- DECLARE @StockersIdsLocal [sys].[varchar](MAX)                                
-- DECLARE @IdUserLocal [sys].[INT]                                
-- DECLARE @CategoryIdsLocal [sys].[varchar](max)                                
-- DECLARE @TypeIdsLocal [sys].[varchar](max)                                
-- DECLARE @TagIdsLocal [sys].[varchar](max)                                
-- DECLARE @OutsidePointOfInterestLocal [sys].[bit]                                
-- DECLARE @IdCompaniesLocal [sys].[varchar](max)                                
                                
-- SET @DateFromTruncated = @DateFrom                                
-- SET @DateToTruncated = @DateTo                                
-- SET @FormIdsLocal = @FormIds                                
-- SET @PointOfInterestIdsLocal = @PointOfInterestIds                                
-- SET @StockersIdsLocal = @StockersIds                                
-- SET @IdUserLocal = @IdUser                                
-- SET @CategoryIdsLocal = @CategoryIds                          
-- SET @TypeIdsLocal = @TypeIds                                
-- SET @TagIdsLocal = @TagIds                                
-- SET @OutsidePointOfInterestLocal = @OutsidePointOfInterest                                
-- SET @IdCompaniesLocal = @IdCompanies                                
                                
-- SELECT  F.[Id], F.[Name], F.[Date], F.[Deleted],                                
--    F.[AllPersonOfInterest], F.[AllPointOfInterest],F.[IsWeighted], F.[NonPointOfInterest],                                
--    F.[IdFormCategory], FC.[Name] AS FormCategoryName,                                
--    F.[IdFormType], PT.[Name] AS FormTypeName,                                
--    COUNT(DISTINCT(P.[Id])) AS CompletedPoints,                                
--    COUNT(DISTINCT(S.[Id])) AS CompletedPersons, 0 AS OutsidePointOfInterest                                
                                 
-- FROM  [dbo].[User] U WITH (NOLOCK)                                
--    INNER JOIN [dbo].[Form] F WITH (NOLOCK) ON F.[IdUser] = U.[Id]                                
--    LEFT OUTER JOIN [dbo].[FormCategory] FC WITH (NOLOCK) ON FC.[Id] = F.[IdFormCategory]                                
--    LEFT OUTER JOIN [dbo].[Parameter] PT WITH (NOLOCK) ON PT.[Id] = F.[IdFormType]                                
--    INNER JOIN [dbo].[CompletedForm] CF WITH (NOLOCK) ON F.[Id] = CF.[IdForm]                                
-- INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = CF.[IdPersonOfInterest]                                
--    LEFT OUTER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON P.[Id] = CF.[IdPointOfInterest]                                
--    left outer join [dbo].[Answer] A ON CF.Id = A.IdCompletedForm AND a.QuestionType = 'TAG'                    
--    left outer join [dbo].[AnswerTag] ATA ON A.Id = ATA.IdAnswer                                
                                
-- WHERE  ((CF.[Date] >= @DateFromTruncated AND CF.[Date] <= @DateToTruncated) OR             
--     (CF.[StartDate] >= @DateFromTruncated AND CF.[StartDate] <= @DateToTruncated)) AND                                
--    ((@FormIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[Id], @FormIdsLocal) = 1)) AND                                
--    ((@CategoryIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormCategory], @CategoryIdsLocal) = 1)) AND                                
--    ((@TypeIdsLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdFormType], @TypeIdsLocal) = 1)) AND                                
--    ((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND                                
--    (@OutsidePointOfInterestLocal IS NULL OR (@OutsidePointOfInterestLocal = 1 AND F.[NonPointOfInterest] = 1)) AND                                
--    ((@StockersIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIdsLocal) = 1)) AND                                
--    ((@IdCompaniesLocal IS NULL) OR (dbo.[CheckValueInList](F.[IdCompany], @IdCompaniesLocal) = 1)) AND                                
--    ((@TagIdsLocal IS NULL) OR ((@TagIdsLocal = '-1' AND ATA.IdAnswer is null) OR (@TagIdsLocal <> '-1' AND ATA.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATA.[IdTag], @TagIdsLocal) = 1))) AND                                
--    ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUserLocal) = 1)) AND                                
--    ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1)) AND                                
--                ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1)) AND                                
--    ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserLocal) = 1))                                
--    AND ((@IdUser IS NULL) OR (dbo.CheckUserInFormCompanies(F.[IdCompany], @IdUser) = 1))                                 
                                 
-- GROUP BY F.[Id], F.[Name], F.[Date], F.[IdFormCategory], FC.[Name], F.[IdFormType], PT.[Name],                                
--  F.[AllPersonOfInterest], F.[AllPointOfInterest], F.[Deleted], F.[NonPointOfInterest], F.[IsWeighted]                                
                                 
-- ORDER BY F.[Date] desc                                
--END
