/****** Object:  Procedure [dbo].[GetCompletedFormsByIdEngage]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		GL
-- Create date: 28/02/2018
-- Description:	SP para obtener los datos completados de un formulario ENGAGE SYNC
-- =============================================
CREATE PROCEDURE [dbo].[GetCompletedFormsByIdEngage]
	@IdForm [sys].[int],
	@DateFrom [sys].[datetime],
	@DateTo [sys].[datetime],
	@ReturnImages [sys].[bit] = 0
AS
BEGIN

	DECLARE @IdFormLocal [sys].[int] = @IdForm
	DECLARE @DateFromLocal [sys].[datetime] = @DateFrom
	DECLARE @DateToLocal [sys].[datetime] = @DateTo
	DECLARE @ReturnImagesLocal [sys].[bit] = @ReturnImages


	SELECT	Min(CF.[Id]) AS Id, CF.[Date], CF.[StartDate], CF.[Latitude] AS [Latitude], 
			CF.[Longitude] AS [Longitude], 
			CF.[InitLatitude] AS [InitLatitude], CF.[InitLongitude] AS [InitLongitude],
			P.[Id] AS PointOfInterestId, P.[Identifier] AS PointOfInterestIdentifier, P.[Name] AS PointOfInterestName, 
			P.[Address] AS PointOfInterestAddress, P.[ContactName],
			P.[ContactPhoneNumber], P.[GrandfatherId] AS HierarchyLevel1Id, P.[FatherId] AS HierarchyLevel2Id,		
			S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName, S.[Id] AS PersonOfInterestId,
			S.[Identifier] AS PersonOfInterestIdentifier, S.[MobileIMEI] AS PersonOfInterestIMEI,
			S.[MobilePhoneNumber] AS PersonOfInterestMobilePhone,
			Q.[Id] AS QuestionID, Q.[Text] AS QuestionText, Q.[Type] AS QuestionType, A.[Id] AS AnswerId,
			Q.[Weight] AS [QuestionWeight], Q.[IsNoWeighted] AS [QuestionIsNoWeighted],
			A.[FreeText] AS AnswerFreeText, A.[Check] AS AnswerCheck, A.[YNOption] AS AnswerYesNoOption, 
			A.[ImageName] AS AnswerImageName, (CASE @ReturnImagesLocal WHEN 1 THEN A.[ImageEncoded] ELSE NULL END) AS AnswerImageArray, 
			A.[DateReply], A.[Skipped],
			QO.[Text] AS AnswerOptionText,QO.[Id] AS AnswerOptionId, PRO.[Name] AS ProductName, PRO.[Identifier] AS ProductIdentifier,
			QO.[Weight] AS [AnswerOptionWeight],
			FM.[IsWeighted] AS IsWeightedForm
	
	FROM		[dbo].[CompletedForm] CF WITH (NOLOCK)
				LEFT OUTER JOIN [dbo].[PointOfInterest] P WITH (NOLOCK) ON CF.[IdPointOfInterest]= P.[Id]
				INNER JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON CF.[IdPersonOfInterest] = S.[Id]
				LEFT OUTER JOIN [dbo].[Question] Q WITH (NOLOCK) ON CF.[IdForm] = Q.[IdForm]
				LEFT OUTER JOIN [dbo].[Answer] A WITH (NOLOCK) ON CF.[Id] = A.[IdCompletedForm] AND A.[IdQuestion] = Q.[Id] 
				LEFT OUTER JOIN [dbo].[QuestionOption] QO WITH (NOLOCK) ON A.[IdQuestionOption] = QO.[Id]
				LEFT OUTER JOIN [dbo].[Product] PRO WITH (NOLOCK) ON Q.[Type] = 'CODE' AND A.[FreeText] = PRO.[BarCode] AND PRO.[Deleted] = 0		
				LEFT OUTER JOIN [dbo].[Form] FM WITH (NOLOCK) ON FM.[Id] = @IdFormLocal
	
	WHERE		CF.[IdForm] = @IdFormLocal AND CF.[Date] BETWEEN @DateFromLocal AND @DateToLocal			
	
	GROUP BY	CF.[Id], CF.[Date], CF.[StartDate], CF.[Latitude], (CASE @ReturnImagesLocal WHEN 1 THEN A.[ImageEncoded] ELSE NULL END),
				CF.[Longitude], CF.[InitLatitude], CF.[InitLongitude],
				P.[Identifier], P.[Name], P.[Address], P.[Id], P.[Identifier], P.[ContactName],
				P.[ContactPhoneNumber], P.[GrandfatherId], P.[FatherId],QO.[Text],QO.Id,PRO.[Name], PRO.[Identifier],QO.Weight,
				S.[Name], S.[LastName], S.[Id], S.[Identifier], S.[MobileIMEI],S.[MobilePhoneNumber],A.[DateReply],A.Skipped,FM.[IsWeighted],
				Q.[Id], Q.[Text], Q.[Type], A.[Id], A.[FreeText], A.[Check], A.[YNOption], A.[ImageName], Q.[Weight], Q.[IsNoWeighted]
	
	ORDER BY	P.[Id], CF.[Date] asc, CF.[Id] asc, Q.[Id]
END
