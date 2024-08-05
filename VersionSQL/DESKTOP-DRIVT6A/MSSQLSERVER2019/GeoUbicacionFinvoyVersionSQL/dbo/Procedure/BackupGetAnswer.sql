/****** Object:  Procedure [dbo].[BackupGetAnswer]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Federico Sobral
-- Create date: 02/10/2019
-- Description:	SP 
-- =============================================
CREATE PROCEDURE [dbo].[BackupGetAnswer]
(
	 @LimitDate [sys].[DATETIME]
)
AS
BEGIN

	SELECT a.[Id],a.[IdQuestion],a.[IdCompletedForm],a.[QuestionType],a.[FreeText],a.[Check],a.[YNOption],a.[DateReply],a.[ImageName],a.[ImageEncoded],a.[Skipped],a.[IdQuestionOption],a.[ImageUrl],a.[DoesNotApply]
	FROM dbo.CompletedForm cf WITH(NOLOCK)
		INNER JOIN dbo.Answer a WITH(NOLOCK) ON cf.id = a.IdCompletedForm
	WHERE cf.[Date] < @LimitDate
	GROUP BY a.[Id],a.[IdQuestion],a.[IdCompletedForm],a.[QuestionType],a.[FreeText],a.[Check],a.[YNOption],a.[DateReply],a.[ImageName],a.[ImageEncoded],a.[Skipped],a.[IdQuestionOption],a.[ImageUrl],a.[DoesNotApply]
	ORDER BY a.[Id] ASC

END
