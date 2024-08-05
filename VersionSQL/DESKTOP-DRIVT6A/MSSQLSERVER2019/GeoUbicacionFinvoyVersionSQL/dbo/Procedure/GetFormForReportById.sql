/****** Object:  Procedure [dbo].[GetFormForReportById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================              
-- Author:  <Author,,Name>              
-- Create date: <Create Date,,>              
-- Description: <Description,,>              
-- =============================================              
CREATE PROCEDURE [dbo].[GetFormForReportById]              
  @Id [sys].[int]              
 ,@DateFrom [sys].[datetime]              
 ,@DateTo [sys].[datetime]              
 ,@PointOfInterestIds [sys].[varchar](MAX) = NULL              
 ,@StockersIds [sys].[varchar](MAX) = NULL              
 ,@TagIds [sys].[varchar](MAX) = NULL              
 ,@IdUser [sys].[INT] = NULL              
 ,@IdDynamic [sys].[INT] = NULL              
AS              
BEGIN              
              
 DECLARE @DateFromTruncated [sys].[datetime]              
 DECLARE @DateToTruncated [sys].[datetime]              
 DECLARE @FormIdLocal [sys].[INT]              
 DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX)              
 DECLARE @StockersIdsLocal [sys].[varchar](MAX)              
 DECLARE @TagIdsLocal [sys].[varchar](MAX)              
 DECLARE @IdUserLocal [sys].[INT]              
 DECLARE @CategoryIdsLocal [sys].[varchar](max)              
 DECLARE @IdDynamicLocal [sys].[INT]              
              
 SET @DateFromTruncated = @DateFrom              
 SET @DateToTruncated = @DateTo              
 SET @FormIdLocal = @Id              
 SET @PointOfInterestIdsLocal = @PointOfInterestIds              
 SET @StockersIdsLocal = @StockersIds              
 SET @TagIdsLocal = @TagIds              
 SET @IdUserLocal = @IdUser              
 SET @IdDynamicLocal = @IdDynamic              
              
 SELECT  F.[Id], F.[Name], F.[Description], F.[IsWeighted], U.[Id] AS IdUser, U.[Name] AS UserName, U.[LastName] AS UserLastName,               
    F.[Date], F.[Deleted], F.[DeletedDate], F.[IdFormCategory], FC.[Name] AS FormCategoryName, F.[OneTimeAnswer],              
    F.[AllPersonOfInterest], F.[AllPointOfInterest], F.[NonPointOfInterest], F.[IdFormType], PT.[Name] AS FormTypeName,              
    COUNT(DISTINCT(P.[Id])) AS CompletedPoints, F.[StartDate] AS FormStartDate,              
    COUNT(DISTINCT(S.[Id])) AS CompletedPersons,              
    F.[IsFormPlus], D.[Id] AS DynamicId, D.[Name] AS DynamicName, D.[StartDate] AS DynamicStartDate, D.[EndDate] AS DynamicEndDate            
              
 FROM  [dbo].[Form] F              
    INNER JOIN [dbo].[User] U ON F.[IdUser] = U.[Id]              
    LEFT JOIN [dbo].[FormCategory] FC ON FC.[Id] = F.[IdFormCategory]              
    LEFT OUTER JOIN [dbo].[Parameter] PT WITH (NOLOCK) ON PT.[Id] = F.[IdFormType]              
    INNER JOIN [dbo].[CompletedForm] CF ON F.[Id] = CF.[IdForm]              
    LEFT OUTER JOIN [dbo].[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]              
    INNER JOIN [dbo].[PersonOfInterest] S ON S.[Id] = CF.[IdPersonOfInterest]              
    LEFT OUTER JOIN [dbo].[Answer] A ON CF.Id = A.IdCompletedForm AND a.QuestionType = 'TAG'              
    LEFT OUTER JOIN [dbo].[AnswerTag] ATA ON A.Id = ATA.IdAnswer              
    LEFT OUTER JOIN [dbo].[DynamicCompletedForm] DCF WITH (NOLOCK) ON CF.[Id] = DCF.[IdCompletedForm]                              
    LEFT OUTER JOIN [dbo].[Dynamic] D WITH (NOLOCK) ON DCF.[IdDynamic] = D.[Id]                              
               
 WHERE  F.[Id] = @FormIdLocal AND              
    ((CF.[Date] >= @DateFromTruncated AND CF.[Date] <= @DateToTruncated) OR              
     (CF.[StartDate] >= @DateFromTruncated AND CF.[StartDate] <= @DateToTruncated)) AND              
    ((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND              
    ((@StockersIdsLocal IS NULL) OR (D.[AllPersonOfInterest] = 1) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIdsLocal) = 1)) AND              
    ((@TagIdsLocal IS NULL) OR ((@TagIdsLocal = '-1' AND ATA.IdAnswer is null) OR (@TagIdsLocal <> '-1' AND ATA.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATA.[IdTag], @TagIdsLocal) = 1))) AND              
    ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUserLocal) = 1)) AND              
    ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(CF.[IdPersonOfInterest], @IdUserLocal) = 1)) AND              
                ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1)) AND              
    ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserLocal) = 1)) AND              
    (D.[Id] IS NULL OR D.[Id] = @IdDynamicLocal)              
               
 GROUP BY F.[Id], F.[Name], U.[Id], U.[Name], U.[LastName], F.[Date], F.[Deleted], F.[DeletedDate],               
    F.[IdFormCategory], FC.[Name], F.[OneTimeAnswer], F.[Description], F.[IsWeighted],              
    F.[AllPersonOfInterest], F.[AllPointOfInterest], F.[NonPointOfInterest], F.[IdFormType], PT.[Name], F.[IsFormPlus], D.[Id], D.[Name], D.[StartDate], D.[EndDate], F.[StartDate]              
              
 ORDER BY F.[Date] ASC              
END
