/****** Object:  Procedure [dbo].[GetMessagePersonsOfInterestByMessageSchedule]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 24/07/2015
-- Description:	SP para obtener las personas de interes de un mensaje agendado
-- =============================================
CREATE PROCEDURE [dbo].[GetMessagePersonsOfInterestByMessageSchedule]
(
	@IdMessage [sys].[int]
)
AS
BEGIN
	SELECT		MS.[IdMessage], MS.[IdPersonOfInterest], S.[Name] AS PersonOfInterestName, S.[LastName] AS PersonOfInterestLastName
	FROM		[dbo].[MessageSchedule] MS INNER JOIN
				[dbo].[PersonOfInterest] S ON S.[Id] = MS.[IdPersonOfInterest]
	WHERE		MS.[IdMessage] = @IdMessage
	ORDER BY	S.[Name], S.[LastName]
END
