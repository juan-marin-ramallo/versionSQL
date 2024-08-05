/****** Object:  Procedure [dbo].[GetMessages]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 30/01/2013
-- Description:	SP para obtener los mensajes
-- =============================================
CREATE PROCEDURE [dbo].[GetMessages]
(
	 @StartDate [sys].[datetime] = NULL
	,@EndDate [sys].[datetime] = NULL
	,@IdPersonsOfInterest [sys].[varchar](MAX) = NULL
	,@IdUser [sys].[int] = NULL
)
AS
BEGIN
	DECLARE @StartDateLocal [sys].[datetime]
	DECLARE @EndDateLocal [sys].[datetime]
	DECLARE @IdPersonsOfInterestLocal [sys].[varchar](MAX)
	DECLARE @IdUserLocal [sys].[INT]

	SET @StartDateLocal = @StartDate
	SET @EndDateLocal = @EndDate
	SET @IdPersonsOfInterestLocal = @IdPersonsOfInterest
	SET @IdUserLocal = @IdUser

IF @IdPersonsOfInterestLocal is null
	begin
		SELECT		M.[Id], M.[Date], M.[Importance], M.[Subject], M.[Message], M.[IdUser], M.[AllowReply],
					U.[Name] AS UserName, U.[LastName] AS UserLastName, M.[TheoricalSentDate], M.[ModifiedDate], M.[Deleted], 
					COUNT(R.[Id]) ReplysCount, COUNT(RU.[Id]) as UnreadMessageReplysCount					
	
		FROM		[dbo].[Message] M WITH (NOLOCK) 
					INNER JOIN [dbo].[User] U WITH (NOLOCK) ON U.[Id] = M.[IdUser]
					--LEFT JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = MP.[IdPersonOfInterest]
					LEFT OUTER JOIN [dbo].[MessageReply] R WITH (NOLOCK) ON R.[IdMessage] = M.[Id]
					LEFT OUTER JOIN [dbo].[MessageReplyUser] RU WITH (NOLOCK) ON RU.[IdMessageReply] = R.[Id] 
					AND @IdUserLocal IS NOT NULL AND RU.[IdUser] = @IdUserLocal

		WHERE		--((Tzdb.FromUtc(M.[Date]) BETWEEN Tzdb.FromUtc(@StartDateLocal) AND Tzdb.FromUtc(@EndDateLocal))
					((Tzdb.IsGreaterOrSameSystemDate(M.[Date], @StartDateLocal) = 1 AND Tzdb.IsLowerOrSameSystemDate(M.[Date], @EndDateLocal) = 1)
						OR RU.[Id] IS NOT NULL) AND
					M.[Deleted] = 0	
	
		GROUP BY	M.[Id], M.[Date], M.[Importance], M.[Subject], M.[Message], M.[IdUser], U.[Name], U.[LastName], 
					M.[TheoricalSentDate], M.[ModifiedDate], M.[Deleted], M.[AllowReply]	
	
		ORDER BY	COUNT(RU.[Id]) desc, M.[Date] DESC
	end
	else
	begin
		SELECT	M.[Id], M.[Date], M.[Importance], M.[Subject], M.[Message], M.[IdUser], M.[AllowReply],
				U.[Name] AS UserName, U.[LastName] AS UserLastName, M.[TheoricalSentDate], M.[ModifiedDate], M.[Deleted], 
				COUNT(R.[Id]) ReplysCount, COUNT(RU.[Id]) as UnreadMessageReplysCount					
	
		FROM		[dbo].[Message] M WITH (NOLOCK) 
					INNER JOIN [dbo].[User] U WITH (NOLOCK) ON U.[Id] = M.[IdUser]
					LEFT JOIN [dbo].[MessagePersonOfInterest] MP WITH (NOLOCK) ON M.[Id] = MP.[IdMessage] AND (dbo.CheckValueInList(MP.[IdPersonOfInterest], @IdPersonsOfInterestLocal) = 1)
					LEFT JOIN [dbo].[MessageSchedule] MS WITH (NOLOCK) ON M.[Id] = MS.[IdMessage] and (dbo.CheckValueInList(MS.[IdPersonOfInterest], @IdPersonsOfInterestLocal) = 1)
					--LEFT JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = MP.[IdPersonOfInterest]
					LEFT OUTER JOIN [dbo].[MessageReply] R WITH (NOLOCK) ON R.[IdMessage] = M.[Id]
					LEFT OUTER JOIN [dbo].[MessageReplyUser] RU WITH (NOLOCK) ON RU.[IdMessageReply] = R.[Id] 
					AND @IdUserLocal IS NOT NULL AND RU.[IdUser] = @IdUserLocal

		WHERE		--((Tzdb.FromUtc(M.[Date]) BETWEEN Tzdb.FromUtc(@StartDateLocal) AND Tzdb.FromUtc(@EndDateLocal))
					((Tzdb.IsGreaterOrSameSystemDate(M.[Date], @StartDateLocal) = 1 AND Tzdb.IsLowerOrSameSystemDate(M.[Date], @EndDateLocal) = 1)
						OR RU.[Id] IS NOT NULL) AND
					--(MS.Id IS NOT NULL OR MP.Id IS NOT NULL) AND
					M.[Deleted] = 0	
	
		GROUP BY	M.[Id], M.[Date], M.[Importance], M.[Subject], M.[Message], M.[IdUser], U.[Name], U.[LastName], 
					M.[TheoricalSentDate], M.[ModifiedDate], M.[Deleted], M.[AllowReply]	
	
	ORDER BY	COUNT(RU.[Id]) desc, M.[Date] DESC
	end

	
END
