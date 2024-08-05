/****** Object:  Procedure [dbo].[GetPendingMessagesToSend]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Gastón Legnani
-- Create date: 27/07/2015
-- Description:	SP para obtener mensajes agendados pendientes de envio.
-- =============================================
CREATE PROCEDURE [dbo].[GetPendingMessagesToSend]
(
	@ProcessDate [sys].[datetime]
)
AS
BEGIN
	SELECT		M.[Id], M.Date, M.[Importance], M.[Subject], M.[Message],M.[TheoricalSentDate], U.[Id] AS IdUser,
				U.[UserName] AS UserName, U.[LastName] AS UserLastName, POI.[Id] AS PersonOfInterestId, POI.[Name] AS PersonOfInterestName,
				POI.[LastName] AS PersonOfInterestLastName
	FROM		[dbo].[MessageSchedule] MS WITH (NOLOCK)
	LEFT JOIN	[dbo].[Message] M WITH (NOLOCK) ON M.Id = MS.IdMessage
	LEFT JOIN	[dbo].[User] U WITH (NOLOCK) ON M.IdUser = U.[Id]
	LEFT JOIN	[dbo].[PersonOfInterest] POI WITH (NOLOCK) ON MS.IdPersonOfInterest = POI.Id 
	WHERE		MS.[SentDate] IS NULL AND M.TheoricalSentDate <= @ProcessDate
				AND M.[Deleted] = 0
END
