/****** Object:  Procedure [dbo].[GetMeetingGuests]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetMeetingGuests]
(
	@IdMeeting [sys].[INT] = 0
)
AS
BEGIN
	SELECT		MG.[Id], MG.[MeetingId], MG.[UserId], MG.[Attended], MG.[CanEdit], MG.[Deleted], MG.[CreatedDate],
				U.[Email] AS Email, U.[Name] AS UserName, U.LastName AS UserLastName, U.Email as UserEmail
	FROM		[dbo].[MeetingGuest] MG
	INNER JOIN  [dbo].[User] U ON U.Id = MG.UserId
	WHERE		MG.MeetingId = @IdMeeting
	AND			MG.Deleted = 0
	ORDER BY	U.[Name], U.LastName
END
