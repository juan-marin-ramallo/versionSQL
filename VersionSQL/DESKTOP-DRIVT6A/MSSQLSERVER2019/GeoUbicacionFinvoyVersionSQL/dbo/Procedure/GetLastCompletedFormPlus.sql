/****** Object:  Procedure [dbo].[GetLastCompletedFormPlus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Javier
-- Create date: 17/04/2023
-- Description:	GetLastCompletedForm
-- =============================================
CREATE PROCEDURE [dbo].[GetLastCompletedFormPlus] 
	-- Add the parameters for the stored procedure here
	@IdForm [sys].[int],
	@IdPersonOfInterest [sys].[int],
	@IdPointOfInterest [sys].[int],
	@IdProduct [sys].[int]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT		CF.[Id], CF.[Date], P.[Latitude], P.[Longitude], P.[Identifier] AS PointOfInterestIdentifier, P.[Name] AS PointOfInterestName, S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName
				, Q.[Id] AS QuestionID, Q.[Text] AS QuestionText, Q.[Type] AS QuestionType, A.[Id] AS AnswerId, 
				A.[FreeText] AS AnswerFreeText, A.[Check] AS AnswerCheck, A.[YNOption] AS AnswerYesNoOption, 
				A.[ImageName] AS AnswerImageName, A.[ImageEncoded] AS AnswerImageArray,A.[ImageUrl] AS ImageUrl,
				A.[DateReply], A.[Skipped], A.[DoesNotApply],
				QO.[Text] AS AnswerOptionText, PRO.[Name] AS ProductName, PRO.[Identifier] AS ProductIdentifier,
				AT.[IdTag], T.[Name] AS TagName
	FROM		[dbo].[CompletedForm] CF
				INNER JOIN [dbo].[PointOfInterest] P ON CF.[IdPointOfInterest]= P.[Id]
				INNER JOIN [dbo].[PersonOfInterest] S ON CF.[IdPersonOfInterest] = S.[Id]
				LEFT OUTER JOIN [dbo].[Question] Q ON CF.[IdForm] = Q.[IdForm]
				LEFT OUTER JOIN [dbo].[Answer] A ON CF.[Id] = A.[IdCompletedForm] AND A.[IdQuestion] = Q.[Id] 
				LEFT OUTER JOIN [dbo].[QuestionOption] QO ON A.[IdQuestionOption] = QO.[Id]
				LEFT OUTER JOIN [dbo].[AnswerTag] AT WITH (NOLOCK) ON AT.[IdAnswer] = A.[Id] AND A.[QuestionType] = 'TAG'
				LEFT OUTER JOIN [dbo].[Tag] T ON T.[Id] = AT.[IdTag]
				LEFT OUTER JOIN [dbo].[Product] PRO ON Q.[Type] = 'CODE' AND A.[FreeText] = PRO.[BarCode]
	WHERE		CF.[IdForm] = @IdForm 
				AND CF.IdPersonOfInterest = @IdPersonOfInterest
				AND CF.IdPointOfInterest = @IdPointOfInterest
				AND CF.IdProduct = @IdProduct
				AND CF.[Id] = (SELECT TOP 1 CF1.Id 
								FROM [dbo].[CompletedForm] CF1 
								WHERE CF1.[IdForm] = @IdForm AND CF1.IdPersonOfInterest = @IdPersonOfInterest AND CF1.IdPointOfInterest = @IdPointOfInterest AND CF1.IdProduct = @IdProduct
								ORDER BY CF1.[Date] desc)
	GROUP BY	CF.[Id], CF.[Date], P.[Latitude], P.[Identifier], P.[Longitude], P.[Name], S.[Name], S.[LastName], 
				Q.[Id], Q.[Text], Q.[Type], A.[Id], A.[FreeText], A.[Check], A.[YNOption], A.[ImageName], A.[ImageUrl], 
				A.[ImageEncoded], A.[DateReply], A.[Skipped], A.[DoesNotApply], QO.[Text], PRO.[Name], PRO.[Identifier],
				AT.[IdTag], T.[Name]
	ORDER BY	Q.[Id]
END
