/****** Object:  Procedure [dbo].[GetCompletedFormsById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================                      
-- Author:  GL                      
-- Create date: 03/06/2015                      
-- Description: SP paa obtener los datos de un formulario completo                      
-- =============================================                      
CREATE PROCEDURE [dbo].[GetCompletedFormsById]                      
 @IdForm [sys].[int]                      
 ,@DateFrom [sys].[datetime]                      
 ,@DateTo [sys].[datetime]                      
 ,@PointOfInterestIds [sys].[varchar](MAX) = NULL                      
 ,@StockersIds [sys].[varchar](MAX) = NULL                      
 ,@TagIds [sys].[varchar](MAX) = NULL                      
 ,@OutsidePointOfInterest [sys].[bit] = NULL                      
 ,@QuestionsIds [sys].[varchar] (MAX) = NULL                      
 ,@IdUser [sys].[INT] = NULL                      
 ,@ReturnImages [sys].[bit] = 0                      
 ,@IdDynamic [sys].[INT] = NULL                      
AS                      
BEGIN                      
                      
 DECLARE @IdFormLocal [sys].[int] = @IdForm                      
 DECLARE @DateFromLocal [sys].[datetime] = @DateFrom                      
 DECLARE @DateToLocal [sys].[datetime] = @DateTo                      
 DECLARE @PointOfInterestIdsLocal [sys].[varchar](MAX) = @PointOfInterestIds                      
 DECLARE @StockersIdsLocal [sys].[varchar](MAX) = @StockersIds                      
 DECLARE @TagIdsLocal [sys].[varchar](MAX) = @TagIds                      
 DECLARE @OutsidePointOfInterestLocal [sys].[bit] = @OutsidePointOfInterest                      
 DECLARE @QuestionsIdsLocal [sys].[varchar] (MAX) = @QuestionsIds                      
 DECLARE @IdUserLocal [sys].[INT] = @IdUser                      
 DECLARE @ReturnImagesLocal [sys].[bit] = @ReturnImages                      
 DECLARE @IdDynamicLocal [sys].[INT] = @IdDynamic                      
                      
                  
                    
                   
  SELECT                  
  CF.Id,                       
  CF.IdForm,                      
  CF.IdPersonOfInterest,                   
  CF.IdPointOfInterest,                   
  CF.Latitude,                     
  CF.Longitude,                     
  CF.LatLong,                      
  CF.[Date],                      
  CF.ReceivedDate,                    
  CF.StartDate,                     
  CF.InitLatitude,                    
  CF.InitLongitude,                    
  CF.CompletedFromWeb,                   
  CF.IdProduct                  
 INTO #CompletedForms                  
 FROM  [dbo].[CompletedForm] CF WITH (NOLOCK)                   
 LEFT OUTER JOIN [dbo].[DynamicCompletedForm] DCF WITH (NOLOCK) ON CF.[Id] = DCF.[IdCompletedForm]                              
 LEFT OUTER JOIN [dbo].[Dynamic] D WITH (NOLOCK) ON DCF.[IdDynamic] = D.[Id]                              
 WHERE CF.[IdForm] = @IdFormLocal AND ((CF.[Date] BETWEEN @DateFromLocal AND @DateToLocal) OR                     
    (CF.[StartDate] BETWEEN @DateFromLocal AND @DateToLocal)) AND                  
    ((@PointOfInterestIdsLocal IS NULL) OR (dbo.[CheckValueInList](CF.[IdPointOfInterest], @PointOfInterestIdsLocal) = 1)) AND                    
    ((@StockersIdsLocal IS NULL) OR (D.[AllPersonOfinterest] = 1) OR (dbo.[CheckValueInList](CF.[IdPersonOfInterest], @StockersIdsLocal) = 1)) AND                    
    ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPointOfInterestZones(CF.[IdPointOfInterest], @IdUserLocal) = 1))                   
                  
                    
                    
                  
  SELECT                  
   Q.[Id],                  
   Q.[Text],                     
   Q.[Type],                     
   Q.[Weight],                    
   Q.[IsNoWeighted],                  
   Q.[IdForm]                  
  INTO #Questions                  
  FROM [dbo].[Question] Q WITH (NOLOCK)                   
  WHERE EXISTS (SELECT TOP 1 1 FROM #CompletedForms CF WHERE Q.[IdForm] = CF.IdForm)                  
     AND ((@QuestionsIdsLocal IS NULL) OR (dbo.[CheckValueInList](Q.[Id], @QuestionsIdsLocal) = 1))                  
                  
                    
  SELECT                    
    Min(CF.[Id]) AS Id,                   
   CF.IdForm,       
        CF.[Date],                   
        CF.[StartDate],                   
        CF.[Latitude] AS [Latitude],                     
        CF.[Longitude] AS [Longitude],                     
        CF.[InitLatitude] AS [InitLatitude],                   
        CF.[InitLongitude] AS [InitLongitude],                    
        P.[Id] AS PointOfInterestId,                   
        P.[Identifier] AS PointOfInterestIdentifier,                   
        P.[Name] AS PointOfInterestName,                     
        P.[Address] AS PointOfInterestAddress, P.[IdDepartment], D.[Name] AS DepartmentName, P.[ContactName],                    
        P.[ContactPhoneNumber], P.[GrandfatherId] AS HierarchyLevel1Id, P.[FatherId] AS HierarchyLevel2Id,                    
        PHL1.[Name] AS HierarchyLevel1Name, PHL2.[Name] AS HierarchyLevel2Name,                       
        S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.[Id] AS PersonOfInterestId,                    
        S.[Identifier] AS PersonOfInterestIdentifier, S.[MobileIMEI] AS PersonOfInterestIMEI,                    
        S.[MobilePhoneNumber] AS PersonOfInterestMobilePhone,                 
        FM.[IsWeighted] AS IsWeightedForm,                  
     PROPlus.[Name] AS ProductNamePlus,                  
     PROPlus.[Identifier] AS ProductIdentifierPlus,                  
     PROPlus.[BarCode] AS ProductBarCodePlus,                  
     Dy.[Id] AS DynamicId,                  
     Dy.[Name] AS DynamicName,                  
     Dy.[StartDate] AS DynamicStartDate,                  
     Dy.[EndDate] AS DynamicEndDate                  
  FROM #CompletedForms CF                  
   LEFT OUTER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK)                   
    ON CF.[IdPointOfInterest]= P.[Id]                    
        INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK)                   
    ON CF.[IdPersonOfInterest] = S.[Id]                    
        LEFT OUTER JOIN [dbo].[Answer] ATF                   
    ON CF.Id = ATF.IdCompletedForm                   
     AND ATF.QuestionType = 'TAG'                    
        LEFT OUTER JOIN [dbo].[AnswerTag] ATAF                   
            ON ATF.Id = ATAF.IdAnswer                    
         LEFT OUTER JOIN [dbo].[Form] FM WITH (NOLOCK)                   
    ON FM.[Id] = @IdFormLocal                    
         LEFT OUTER JOIN [dbo].[Department] D WITH (NOLOCK)                   
    ON P.[IdDepartment] = D.[Id]                     
         LEFT OUTER JOIN [dbo].[POIHierarchyLevel1] PHL1 WITH (NOLOCK)                   
    ON P.[GrandfatherId] = PHL1.[Id]                     
         LEFT OUTER JOIN [dbo].[POIHierarchyLevel2] PHL2 WITH (NOLOCK)                   
    ON P.[FatherId] = PHL2.[Id]                    
   LEFT OUTER JOIN [dbo].[Product] PROPlus WITH (NOLOCK)                   
    ON FM.[IsFormPlus] = 1                   
    AND CF.[IdProduct] = PROPlus.[Id]                      
    LEFT OUTER JOIN [dbo].[DynamicCompletedForm] DCF WITH (NOLOCK) ON CF.[Id] = DCF.[IdCompletedForm]                   
    LEFT OUTER JOIN [dbo].[Dynamic] Dy WITH (NOLOCK) ON DCF.[IdDynamic] = Dy.[Id]                   
  WHERE                    
   (@OutsidePointOfInterestLocal IS NULL OR (@OutsidePointOfInterestLocal = 1 AND FM.[NonPointOfInterest] = 1)) AND                    
   ((@TagIdsLocal IS NULL) OR ((@TagIdsLocal = '-1' AND ATAF.IdAnswer is null) OR (@TagIdsLocal <> '-1' AND ATAF.IdTag IS NOT NULL AND dbo.[CheckValueInList](ATAF.[IdTag], @TagIdsLocal) = 1))) AND                    
   ((@IdUserLocal IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUserLocal) = 1)) AND                    
   ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUserLocal) = 1)) AND                    
   ((@IdUserLocal IS NULL) OR (dbo.CheckDepartmentInUserDepartments(P.[IdDepartment], @IdUserLocal) = 1)) AND                    
   (Dy.[Id] IS NULL OR @IdDynamicLocal = 0 OR Dy.[Id] = @IdDynamicLocal)                  
                  
   GROUP BY CF.[Id],CF.IdForm, CF.[Date], CF.[StartDate], CF.[Latitude],                     
   CF.[Longitude], CF.[InitLatitude], CF.[InitLongitude],                    
   P.[Identifier], P.[Name], P.[Address], P.[Id], P.[Identifier],                    
   P.[IdDepartment], D.[Name], P.[ContactName],                    
   P.[ContactPhoneNumber], P.[GrandfatherId], P.[FatherId],PHL1.[Name], PHL2.[Name],                    
 S.[Name], S.[LastName], S.[Id], S.[Identifier], S.[MobileIMEI],S.[MobilePhoneNumber],                    
   FM.[IsWeighted],                  
   PROPlus.[Name], PROPlus.[Identifier], PROPlus.[BarCode], Dy.[Id], Dy.[Name], Dy.[StartDate], Dy.[EndDate]                  
  ORDER BY CF.[Date] asc,                  
   P.[Id],                  
   CF.[Id] asc                  
                              
                  
  SELECT  * FROM #Questions                   
                  
                    
  SELECT                   
   A.Id,                  
   A.IdCompletedForm,                  
   A.IdQuestion,                  
   A.[FreeText],                   
   A.[Check],                   
   A.[YNOption],                     
   A.[ImageName],                   
   (CASE @ReturnImagesLocal WHEN 1 THEN A.[ImageEncoded] ELSE NULL END) AS AnswerImageArray,                     
   A.[ImageUrl] ,                     
   A.[DateReply],                   
   A.[Skipped],                  
   A.[DoesNotApply],                   
   T.[Id] AS IdTag,                   
   T.[Name] TagName,                   
   QO.[Text] AS AnswerOptionText,                  
   QO.[Id] AS AnswerOptionId,                   
   QO.[Weight] AS AnswerOptionWeight,                   
   QO.[IsNotApply] AS AnswerOptionIsNotApply                   
   ,PRO.[Name] AS ProductName                  
   ,PRO.[Identifier] AS ProductIdentifier                  
   ,PRO.[BarCode] AS ProductBarCode                  
    FROM [dbo].[Answer] A WITH (NOLOCK)                  
   LEFT OUTER JOIN [dbo].[AnswerTag] ANT WITH (NOLOCK)                   
    ON A.Id = ANT.IdAnswer                    
   LEFT OUTER JOIN [dbo].[Tag] T WITH (NOLOCK)                   
    ON ANT.IdTag = T.Id                    
        LEFT OUTER JOIN [dbo].[QuestionOption] QO WITH (NOLOCK)                   
    ON A.[IdQuestionOption] = QO.[Id]                   
   LEFT OUTER JOIN [dbo].[Product] PRO WITH (NOLOCK) ON A.[QuestionType] = 'CODE'                   
               AND A.[FreeText] = PRO.[BarCode]                   
               AND PRO.[Deleted] = 0                  
  WHERE  EXISTS (SELECT TOP 1 1 FROM #Questions Q WHERE A.[IdQuestion] = Q.Id)                      
    AND EXISTS (SELECT TOP 1 1 FROM #CompletedForms CF WHERE A.IdCompletedForm = CF.Id)                     
  GROUP BY                   
   A.[Id],                   
   A.IdCompletedForm,                  
   A.IdQuestion,                  
   A.[FreeText], A.[Check], A.[YNOption], A.[ImageName],                  
   (CASE @ReturnImagesLocal WHEN 1 THEN A.[ImageEncoded] ELSE NULL END),                      
   A.[ImageUrl] , A.[DoesNotApply],                   
   A.[DateReply], A.[Skipped],                   
   T.[Id], T.[Name],                      
   QO.[Text],                  
   PRO.[Name],                   
   PRO.[Identifier],                  
   PRO.[BarCode],                  
   QO.[Weight], QO.[IsNotApply],QO.[Id]                  
  DROP TABLE #CompletedForms                  
  DROP TABLE #Questions                  
                  
                  
  SELECT DCF.[IdCompletedForm], DR.[Name], DRV.[Value]    
  FROM [DynamicCompletedForm] DCF WITH (NOLOCK)    
  INNER JOIN [DynamicReferenceCompletedForm] DRCF WITH (NOLOCK) ON DCF.[Id] = DRCF.[IdDynamicCompletedForm]    
  INNER JOIN [CompletedForm] CF WITH (NOLOCK) ON DCF.[IdCompletedForm] = CF.[Id] AND CF.[IdForm] = @IdFormLocal    
  LEFT JOIN [DynamicReference] DR WITH (NOLOCK) ON DRCF.[IdDynamicReference] = DR.[Id]    
  LEFT JOIN [DynamicReferenceValue] DRV WITH (NOLOCK) ON DRCF.[IdDynamicReferenceValue] = DRV.[Id]    
END
