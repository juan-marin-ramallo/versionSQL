/****** Object:  Procedure [dbo].[GetAnswerImageById]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAnswerImageById] 
	@AnswerId int
AS
BEGIN

	SELECT		A.[ImageEncoded], CF.[Date],  P.[Identifier], P.[Name], A.[ImageUrl], A.[ImageName]
	
	FROM		dbo.[Answer] A
	LEFT JOIN	dbo.[CompletedForm] CF ON CF.[Id] = A.[IdCompletedForm]
	LEFT JOIN	dbo.[PointOfInterest] P ON P.[Id] = CF.[IdPointOfInterest]
	
	WHERE		A.[Id] = @AnswerId

END
