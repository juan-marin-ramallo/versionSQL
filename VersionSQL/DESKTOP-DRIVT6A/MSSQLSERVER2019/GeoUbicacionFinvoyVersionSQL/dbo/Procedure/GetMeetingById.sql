/****** Object:  Procedure [dbo].[GetMeetingById]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetMeetingById]
(
	@IdUser [sys].[int] = 0,
	@MeetingId [sys].[int] = 0
)
AS
BEGIN
	DECLARE @TimeToBlockMinute INT = (SELECT TOP 1 [Value] FROM dbo.[ConfigurationTranslated] WITH (NOLOCK) WHERE Id = 3049)

	SELECT		M.[Id], M.[Subject], M.[Start], M.[End], M.[UserId], M.[ActualStart], M.[ActualEnd], M.[Minute], M.[Deleted], M.[CreatedDate],
				M.[Description], M.[MicrosoftEventId], M.[MinuteSent], M.[MinuteFileName], M.[MinuteRealFileName], M.[MinuteFileEncoded],
				M.[SignaturesFileName], M.[SignaturesRealFileName], M.[SignaturesFileEncoded], M.[Synced], M.[SyncType], M.[IsFixed],
				U.[Name] AS UserName, U.LastName AS UserLastName,
				(CASE WHEN @IdUser = M.UserId OR (MG.Id IS NOT NULL AND MG.CanEdit = 1) THEN 1 ELSE 0 END) AS CanEdit,
				(CASE WHEN M.ActualEnd IS NOT NULL THEN DATEADD(HOUR, @TimeToBlockMinute, M.ActualEnd) ELSE NULL END) AS BlockMinute
	FROM		[dbo].[Meeting] M
				INNER JOIN  [dbo].[User] U ON U.Id = M.UserId
				LEFT OUTER JOIN dbo.MeetingGuest MG ON MG.MeetingId = M.id AND MG.UserId = @IdUser
	WHERE		M.Id = @MeetingId
END
