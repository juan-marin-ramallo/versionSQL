/****** Object:  Procedure [dbo].[GetMessagesByUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 25/02/2013
-- Description:	SP para obtener los mensajes de un usuario
-- =============================================
CREATE PROCEDURE [dbo].[GetMessagesByUser]
(
	 @IdUser [sys].[int]
	,@StartDate [sys].DATETIME = NULL
	,@EndDate [sys].DATETIME = NULL
	,@IdPersonsOfInterest [sys].[varchar](MAX) = NULL
	,@ShowOnlyDeletedMessages [sys].[BIT] = NULL
)
AS
BEGIN
	SELECT		M.[Id], M.[Date], M.[Importance], M.[Subject], M.[Message], M.[IdUser], U.[Name] AS UserName, 
				U.[LastName] AS UserLastName, M.[TheoricalSentDate], M.[ModifiedDate], M.[Deleted], M.[AllowReply], 
				COUNT(R.[Id]) ReplysCount, COUNT(RU.[Id]) as UnreadMessageReplysCount				
	FROM		[dbo].[Message] M WITH (NOLOCK)
				INNER JOIN [dbo].[User] U WITH (NOLOCK) ON U.[Id] = M.[IdUser]
				LEFT JOIN [dbo].[MessagePersonOfInterest] MP WITH (NOLOCK) ON M.[Id] = MP.[IdMessage]
				LEFT JOIN [dbo].[MessageSchedule] MS WITH (NOLOCK) ON M.[Id] = MS.[IdMessage]
				LEFT JOIN [dbo].[PersonOfInterest] S WITH (NOLOCK) ON S.[Id] = MP.[IdPersonOfInterest]
				LEFT OUTER JOIN [dbo].[MessageReply] R WITH (NOLOCK) ON R.[IdMessage] = M.[Id]
				LEFT OUTER JOIN [dbo].[MessageReplyUser] RU WITH (NOLOCK) ON RU.[IdMessageReply] = R.[Id] AND @IdUser IS NOT NULL AND RU.[IdUser] = @IdUser
	WHERE		((@IdUser = 1) OR (U.[Id] = @IdUser)) AND --USUARIO 1 ES XSEED. Pára que los vea todos
				--(CAST(Tzdb.FromUtc(M.[Date]) AS [sys].[date]) BETWEEN CAST(Tzdb.FromUtc(@StartDate) AS [sys].[date]) AND CAST(Tzdb.FromUtc(@EndDate) AS [sys].[date])) AND	
				(Tzdb.IsGreaterOrSameSystemDate(M.[Date], @StartDate) = 1 AND Tzdb.IsLowerOrSameSystemDate(M.[Date], @EndDate) = 1) AND
				(((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(MP.[IdPersonOfInterest], @IdPersonsOfInterest) = 1)) OR
				((@IdPersonsOfInterest IS NULL) OR (dbo.CheckValueInList(MS.[IdPersonOfInterest], @IdPersonsOfInterest) = 1))) AND
				((@IdUser IS NULL) OR (dbo.CheckUserInPersonOfInterestZones(S.[Id], @IdUser) = 1)) AND
				((@IdUser IS NULL) OR (dbo.CheckDepartmentInUserDepartments(S.[IdDepartment], @IdUser) = 1)) AND
				((@ShowOnlyDeletedMessages = 0 AND M.[Deleted] = 0) OR (@ShowOnlyDeletedMessages = 1 AND M.[Deleted] = 1))
	
	GROUP BY	M.[Id], M.[Date], M.[Importance], M.[Subject], M.[Message], M.[IdUser], U.[Name], U.[LastName], 
				M.[TheoricalSentDate], M.[ModifiedDate], M.[Deleted], M.[AllowReply]	
	ORDER BY	COUNT(RU.[Id]) DESC, M.[Date] DESC
END
