/****** Object:  Procedure [dbo].[GetCompletedFormsFilteredApi]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE PROCEDURE [dbo].[GetCompletedFormsFilteredApi]    
  @FormNames [sys].[varchar](MAX) = NULL    
 ,@DateFrom [sys].[datetime]    
 ,@DateTo [sys].[datetime]    
 ,@PointOfInterestIdentifiers [sys].[varchar](MAX) = NULL    
 ,@PersonOfInterestIdentifiers [sys].[varchar](MAX) = NULL    
 ,@OutsidePointOfInterest [sys].[bit] = NULL    
 ,@FormTypeId [sys].[int] = NULL    
AS    
BEGIN    
 SELECT  Min(CF.[Id]) AS Id, CF.[Date], CF.[StartDate], ISNULL(P.[Latitude], CF.[Latitude]) AS [Latitude],     
    ISNULL(P.[Longitude], CF.[Longitude]) AS [Longitude],     
    P.[Id] AS PointOfInterestId, P.[Identifier] AS PointOfInterestIdentifier,     
    ISNULL(P.[Name], '') AS PointOfInterestName, ISNULL(P.[Address], '') AS PointOfInterestAddress,     
    S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName,     
    S.[Identifier] AS PersonOfInterestIdentifier, S.[MobileIMEI] AS PersonOfInterestImei,    
    S.[MobilePhoneNumber] AS PersonOfInterestPhoneNumber, S.[Id] AS PersonOfInterestId,    
    Q.[Id] AS QuestionID, Q.[Text] AS QuestionText, Q.[Type] AS QuestionType, A.[Id] AS AnswerId,    
    Q.[Weight] AS [QuestionWeight], Q.[IsNoWeighted] AS [QuestionIsNoWeighted], Q.[Required] AS QuestionRequired,    
    A.[FreeText] AS AnswerFreeText, A.[Check] AS AnswerCheck, A.[YNOption] AS AnswerYesNoOption,    
    A.[ImageName] AS AnswerImageName, A.[DateReply], A.[Skipped],    
    QO.[Text] AS AnswerOptionText, PRO.[Name] AS ProductName, PRO.[Identifier] AS ProductIdentifier,    
    QO.[Id] AS AnswerOptionId, QO.[Weight] AS [AnswerOptionWeight],    
    FM.[IsWeighted] AS IsWeightedForm, CF.[IdForm],    
    FM.[Name] AS FormName, FM.[StartDate] AS FormStartDate, FM.[EndDate] AS FormEndDate,     
    FM.[Description] AS FormDescription, FM.[IsWeighted] AS FormIsWeighted,    
    FM.[IdFormCategory], FC.[Name] as FormCategoryName, FM.[NonPointOfInterest] AS FormIsGeneric,    
    FM.[IdFormType], PA.[Name] AS FormTypeName, A.[DoesNotApply]  
  
 FROM  [dbo].[CompletedForm] CF WITH(NOLOCK)    
    INNER JOIN [dbo].[Form] FM WITH(NOLOCK) ON CF.[IdForm] = FM.[Id]    
    INNER JOIN [dbo].[PersonOfInterest] S WITH(NOLOCK) ON CF.[IdPersonOfInterest] = S.[Id]    
    LEFT OUTER JOIN [dbo].[PointOfInterest] P WITH(NOLOCK) ON CF.[IdPointOfInterest]= P.[Id]    
    LEFT OUTER JOIN [dbo].[Question] Q WITH(NOLOCK) ON CF.[IdForm] = Q.[IdForm]    
    LEFT OUTER JOIN [dbo].[Answer] A WITH(NOLOCK) ON CF.[Id] = A.[IdCompletedForm] AND A.[IdQuestion] = Q.[Id]     
    LEFT OUTER JOIN [dbo].[QuestionOption] QO WITH(NOLOCK) ON A.[IdQuestionOption] = QO.[Id]    
    LEFT OUTER JOIN [dbo].[Product] PRO WITH(NOLOCK) ON Q.[Type] = 'CODE' AND A.[FreeText] = PRO.[BarCode] AND PRO.[Deleted] = 0      
    LEFT OUTER JOIN [dbo].[FormCategory] FC WITH(NOLOCK) ON FM.[IdFormCategory] = FC.[Id]    
    LEFT OUTER JOIN [dbo].[Parameter] PA WITH(NOLOCK) ON FM.[IdFormType] = PA.[Id]    
  
 WHERE  CF.[Date] BETWEEN @DateFrom AND @DateTo AND    
    ((@FormNames IS NULL) OR (dbo.[CheckVarcharInList](FM.[Name], @FormNames) = 1)) AND    
    ((@FormTypeId IS NULL) OR (FM.[IdFormType] = @FormTypeId)) AND    
    (@OutsidePointOfInterest IS NULL OR (@OutsidePointOfInterest = 1 AND P.[Id] IS NULL)) AND    
    ((@PersonOfInterestIdentifiers IS NULL) OR (dbo.[CheckVarcharInList](S.[Identifier], @PersonOfInterestIdentifiers) = 1)) AND    
    ((@PointOfInterestIdentifiers IS NULL) OR (dbo.[CheckVarcharInList](P.[Identifier], @PointOfInterestIdentifiers) = 1))    
     
 GROUP BY CF.[Id], CF.[Date], CF.[StartDate], ISNULL(P.[Latitude], CF.[Latitude]), ISNULL(P.[Longitude], CF.[Longitude]), P.[Id], P.[Identifier], ISNULL(P.[Name], ''), ISNULL(P.[Address], ''), S.[Name], S.[LastName],     
    Q.[Id], Q.[Text], Q.[Type], A.[Id], A.[FreeText], A.[Check], A.[YNOption], A.[ImageName], Q.[Weight], Q.[IsNoWeighted],    
   A.[ImageEncoded], A.[DateReply], A.[Skipped], QO.[Id], QO.[Text], PRO.[Name], PRO.[Identifier],     
    QO.[Weight], FM.[IsWeighted], S.[Identifier] , S.[MobileIMEI], S.[MobilePhoneNumber], S.[Id],CF.[IdForm],    
    FM.[Name], FM.[StartDate], FM.[EndDate], FM.[IdFormCategory], FM.[IsWeighted],    
    FC.[Name] , Q.[Required], FM.[Description], FM.[NonPointOfInterest], FM.[IdFormType], PA.[Name], A.[DoesNotApply]    
    
 ORDER BY CF.[Date] asc, CF.[Id] asc, Q.[Id]    
END
