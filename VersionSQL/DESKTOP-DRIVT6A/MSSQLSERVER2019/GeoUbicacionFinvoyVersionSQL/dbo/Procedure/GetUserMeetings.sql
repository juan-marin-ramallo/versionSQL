/****** Object:  Procedure [dbo].[GetUserMeetings]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetUserMeetings]
(
	@IdUser [sys].[int] = 0,
	@DateFrom [sys].DATETIME,
    @DateTo [sys].DATETIME,
    @OnlyMyMeetings [sys].[bit]
)
AS
BEGIN
	DECLARE @TimeToBlockMinute INT = (SELECT TOP 1 [Value] FROM dbo.[ConfigurationTranslated] WITH (NOLOCK) WHERE Id = 3049)

	SELECT	M.[Id], M.[Subject], M.[Start], M.[End], M.[UserId], M.[ActualStart], M.[ActualEnd], M.[Minute], M.[Deleted], M.[CreatedDate],
			M.[Description], M.[MicrosoftEventId], M.[MinuteSent], M.[MinuteFileName], M.[MinuteRealFileName], M.[MinuteFileEncoded],
			M.[SignaturesFileName], M.[SignaturesRealFileName], M.[SignaturesFileEncoded], M.[Synced], M.[SyncType], M.[IsFixed],
			U.[Name] AS UserName, U.LastName AS UserLastName,
			(CASE WHEN @IdUser = M.UserId OR (MG.Id IS NOT NULL AND MG.CanEdit = 1) THEN 1 ELSE 0 END) AS CanEdit,
			(CASE WHEN M.ActualEnd IS NOT NULL THEN DATEADD(HOUR, @TimeToBlockMinute, M.ActualEnd) ELSE NULL END) AS BlockMinute
	FROM	[dbo].[ApprovedMeeting] M WITH(NOLOCK)
			INNER JOIN  [dbo].[User] U WITH(NOLOCK) ON U.Id = M.UserId
			LEFT OUTER JOIN dbo.MeetingGuest MG WITH(NOLOCK) ON MG.MeetingId = M.id AND MG.UserId = @IdUser
	WHERE	(M.UserId = @IdUser OR (@OnlyMyMeetings = 0 AND MG.Id IS NOT NULL)) AND 
			--(((CAST(M.[Start] AS DATE) >= CAST(@DateFrom AS DATE)) AND (CAST(M.[Start] AS DATE) <= CAST(@DateTo AS DATE))) OR
			--((CAST(M.[ActualStart] AS DATE) >= CAST(@DateFrom AS DATE)) AND (CAST(M.[ActualEnd] AS DATE) <= CAST(@DateTo AS DATE))))
			((Tzdb.IsGreaterOrSameSystemDate(M.[Start], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate(M.[Start], @DateTo) = 1) OR
			(Tzdb.IsGreaterOrSameSystemDate(M.[ActualStart], @DateFrom) = 1 AND Tzdb.IsLowerOrSameSystemDate(M.[ActualEnd], @DateTo) = 1))
	ORDER BY M.[Start] DESC
END
