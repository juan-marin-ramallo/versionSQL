/****** Object:  Procedure [dbo].[GetCompletedFormsByDynamicId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================                    
-- Author:  GL                    
-- Create date: 03/06/2015                    
-- Description: SP paa obtener los datos de un formulario completo                    
-- =============================================                    
CREATE PROCEDURE [dbo].[GetCompletedFormsByDynamicId]                    
 @IdDynamic [sys].[int],                    
 @DateFrom [sys].[datetime],                    
 @DateTo [sys].[datetime],                    
 @PointOfInterestIds [sys].[varchar](MAX) = NULL                    
 ,@QuestionsIds [sys].[varchar] (MAX) = NULL                    
 ,@IdUser [sys].[INT] = NULL,                    
 @ReturnImages [sys].[bit] = 0                    
AS                    
BEGIN                    
                    
 DECLARE @IdDynamicLocal [sys].[int] = @IdDynamic                    
 DECLARE @DateFromLocal [sys].[datetime] = @DateFrom                    
 DECLARE @DateToLocal [sys].[datetime] = @DateTo                    
 DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX) = @PointOfInterestIds                    
 DECLARE @QuestionsIdsLocal [sys].[varchar] (MAX) = @QuestionsIds                    
 DECLARE @IdUserLocal [sys].[INT] = @IdUser                    
 DECLARE @ReturnImagesLocal [sys].[bit] = @ReturnImages                    
                    
                    
 SELECT Min(CF.[Id]) AS Id, CF.[Date], CF.[StartDate], CF.[Latitude] AS [Latitude],                     
   CF.[Longitude] AS [Longitude],                     
   CF.[InitLatitude] AS [InitLatitude], CF.[InitLongitude] AS [InitLongitude],                    
   P.[Id] AS PointOfInterestId, P.[Identifier] AS PointOfInterestIdentifier, P.[Name] AS PointOfInterestName,                     
   P.[Address] AS PointOfInterestAddress, P.[IdDepartment], D.[Name] AS DepartmentName, P.[ContactName],                    
   P.[ContactPhoneNumber], P.[GrandfatherId] AS HierarchyLevel1Id, P.[FatherId] AS HierarchyLevel2Id,                    
   PHL1.[Name] AS HierarchyLevel1Name, PHL2.[Name] AS HierarchyLevel2Name,                       
   S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.[Id] AS PersonOfInterestId,                    
   S.[Identifier] AS PersonOfInterestIdentifier, S.[MobileIMEI] AS PersonOfInterestIMEI,                    
   S.[MobilePhoneNumber] AS PersonOfInterestMobilePhone,                    
   Q.[Id] AS QuestionID, Q.[Text] AS QuestionText, Q.[Type] AS QuestionType, A.[Id] AS AnswerId,                    
   Q.[Weight] AS [QuestionWeight], Q.[IsNoWeighted] AS [QuestionIsNoWeighted],                    
   A.[FreeText] AS AnswerFreeText, A.[Check] AS AnswerCheck, A.[YNOption] AS AnswerYesNoOption,                     
   A.[ImageName] AS AnswerImageName, (CASE @ReturnImagesLocal WHEN 1 THEN A.[ImageEncoded] ELSE NULL END) AS AnswerImageArray,                     
   A.[ImageUrl] AS AnswerImageUrl,                     
   A.[DateReply], A.[Skipped],                    
   QO.[Text] AS AnswerOptionText,QO.[Id] AS AnswerOptionId, PRO.[Name] AS ProductName, PRO.[Identifier] AS ProductIdentifier,                    
   QO.[Weight] AS [AnswerOptionWeight], QO.[IsNotApply] AS AnswerOptionIsNotApply,                    
   FM.[IsWeighted] AS IsWeightedForm,                    
   A.[DoesNotApply], T.[Id] AS TagId, T.[Name] AS TagName,                    
   PROPlus.[Name] AS ProductNamePlus,                  
   PROPlus.[Identifier] AS ProductIdentifierPlus,                  
   PROPlus.[BarCode] AS ProductBarCodePlus,                  
   Dy.[Id] AS DynamicId,                  
   Dy.[Name] AS DynamicName,                  
   Dy.[StartDate] AS DynamicStartDate,                  
   Dy.[EndDate] AS DynamicEndDate,                  
   C.[Name] AS CompanyName,                  
   C.[Identifier] AS CompanyIdentifier                  
                     
 FROM  [dbo].[CompletedForm] CF WITH (NOLOCK)                    
    LEFT OUTER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON CF.[IdPointOfInterest]= P.[Id]                    
    INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON CF.[IdPersonOfInterest] = S.[Id]                    
    LEFT OUTER JOIN [dbo].[Answer] ATF ON CF.Id = ATF.IdCompletedForm AND ATF.QuestionType = 'TAG'                  
    LEFT OUTER JOIN [dbo].[AnswerTag] ATAF ON ATF.Id = ATAF.IdAnswer                    
    LEFT OUTER JOIN [dbo].[Question] Q WITH (NOLOCK) ON CF.[IdForm] = Q.[IdForm]                    
    LEFT OUTER JOIN [dbo].[Answer] A WITH (NOLOCK) ON CF.[Id] = A.[IdCompletedForm] AND A.[IdQuestion] = Q.[Id]                     
    LEFT OUTER JOIN [dbo].[QuestionOption] QO WITH (NOLOCK) ON A.[IdQuestionOption] = QO.[Id]                    
    LEFT OUTER JOIN [dbo].[Product] PRO WITH (NOLOCK) ON Q.[Type] = 'CODE' AND A.[FreeText] = PRO.[BarCode] AND PRO.[Deleted] = 0                      
    LEFT OUTER JOIN [dbo].[AnswerTag] ANT WITH (NOLOCK) ON A.Id = ANT.IdAnswer                    
    LEFT OUTER JOIN [dbo].[Tag] T WITH (NOLOCK) ON ANT.IdTag = T.Id                    
    LEFT OUTER JOIN [dbo].[Form] FM WITH (NOLOCK) ON FM.[Id] = CF.[IdForm]                    
    LEFT OUTER JOIN [dbo].[Department] D WITH (NOLOCK) ON P.[IdDepartment] = D.[Id]                     
    LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] PHL1 WITH (NOLOCK) ON P.[GrandfatherId] = PHL1.[Id]                     
    LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] PHL2 WITH (NOLOCK) ON P.[FatherId] = PHL2.[Id]                    
    LEFT OUTER JOIN [dbo].[Product] PROPlus WITH (NOLOCK) ON FM.[IsFormPlus] = 1 AND CF.[IdProduct] = PROPlus.[Id]                    
    LEFT OUTER JOIN [dbo].[DynamicCompletedForm] DCF WITH (NOLOCK) ON CF.[Id] = DCF.[IdCompletedForm]                    
    LEFT OUTER JOIN [dbo].[Dynamic] Dy WITH (NOLOCK) ON DCF.[IdDynamic] = Dy.[Id]                    
    LEFT OUTER JOIN [dbo].[ProductBrand] PB WITH (NOLOCK) ON PRO.[IdProductBrand] = PB.[Id]                    
    LEFT OUTER JOIN [dbo].[Company] C WITH (NOLOCK) ON PB.[IdCompany] = C.[Id]                    
                     
 WHERE  Dy.[Id] = @IdDynamicLocal AND ((CF.[Date] BETWEEN @DateFromLocal AND @DateToLocal) OR                     
    (CF.[StartDate] BETWEEN @DateFromLocal AND @DateToLocal)) AND                    
    ((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND                    
    ((@QuestionsIdsLocal IS NULL) OR (dbo.[CheckValueInList](Q.[Id], @QuestionsIdsLocal) = 1)) AND                    
    ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUserLocal) = 1)) AND                    
    ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1)) AND                    
                ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1)) AND                    
    ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserLocal) = 1))                    
                     
 GROUP BY CF.[Id], CF.[Date], CF.[StartDate], CF.[Latitude],                     
    CF.[Longitude], CF.[InitLatitude], CF.[InitLongitude],                    
    P.[Identifier], P.[Name], P.[Address], P.[Id], P.[Identifier],                    
    P.[IdDepartment], D.[Name], P.[ContactName],                    
    P.[ContactPhoneNumber], P.[GrandfatherId], P.[FatherId],PHL1.[Name], PHL2.[Name],                    
    S.[Name], S.[LastName], S.[Id], S.[Identifier], S.[MobileIMEI],S.[MobilePhoneNumber],                    
    Q.[Id], Q.[Text], Q.[Type], A.[Id], A.[FreeText], A.[Check], A.[YNOption], A.[ImageName], Q.[Weight], Q.[IsNoWeighted],                    
    (CASE @ReturnImagesLocal WHEN 1 THEN A.[ImageEncoded] ELSE NULL END),                    
    A.[ImageUrl] , A.[DoesNotApply], T.[Id], T.[Name],                    
     A.[DateReply], A.[Skipped], QO.[Text], PRO.[Name], PRO.[Identifier], QO.[Weight], QO.[IsNotApply], FM.[IsWeighted],QO.[Id],PROPlus.[Name],PROPlus.[Identifier],PROPlus.[BarCode],Dy.[Id],Dy.[Name],Dy.[StartDate],Dy.[EndDate],C.[Name],C.[Identifier]   
                 
                     
 ORDER BY CF.[Date] asc, P.[Id], CF.[Id] asc, Q.[Id], T.[Id]                    
          
 SELECT CF.[Id] AS IdCompletedForm, DCF.[IdDynamic], DR.[Name], DRV.[Value]          
 FROM [dbo].[CompletedForm] CF WITH (NOLOCK)          
 INNER JOIN [dbo].[DynamicCompletedForm] DCF WITH (NOLOCK) ON CF.[Id] = DCF.[IdCompletedForm]          
 INNER JOIN [dbo].[DynamicReferenceCompletedForm] DRCF WITH (NOLOCK) ON DCF.[Id] = DRCF.[IdDynamicCompletedForm]          
 LEFT OUTER JOIN [dbo].[DynamicReference] DR WITH (NOLOCK) ON DRCF.[IdDynamicReference] = DR.[Id]          
 LEFT OUTER JOIN [dbo].[DynamicReferenceValue] DRV WITH (NOLOCK) ON DRCF.[IdDynamicReferenceValue] = DRV.[Id]          
 WHERE DCF.[IdDynamic] = @IdDynamicLocal          
END
