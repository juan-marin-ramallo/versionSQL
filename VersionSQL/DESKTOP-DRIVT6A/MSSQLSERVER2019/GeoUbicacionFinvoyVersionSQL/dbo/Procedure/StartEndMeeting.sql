/****** Object:  Procedure [dbo].[StartEndMeeting]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[StartEndMeeting]
(
	@IdMeeting [sys].[int]
)
AS
BEGIN

	UPDATE MG SET MG.Attended = 0
	FROM dbo.MeetingGuest MG
	INNER JOIN dbo.Meeting M ON M.Id = MG.MeetingId
	WHERE M.Id = @IdMeeting AND M.ActualStart IS NULL

	UPDATE dbo.Meeting SET
    ActualStart = (CASE WHEN ActualStart IS NULL THEN GETUTCDATE() ELSE ActualStart END),
    ActualEnd = (CASE WHEN ActualStart IS NOT NULL AND ActualEnd IS NULL THEN GETUTCDATE() ELSE ActualEnd END)
	WHERE Id = @IdMeeting 

	SELECT ActualStart, ActualEnd
	FROM dbo.Meeting
	WHERE Id = @IdMeeting
END
