/****** Object:  Procedure [dbo].[GetMeetingsToSend]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetMeetingsToSend]

AS
BEGIN
	DECLARE @TimeToBlockMinute INT = (SELECT TOP 1 [Value] FROM dbo.[Configuration] WITH (NOLOCK) WHERE Id = 3049)

	DECLARE @Table1 TABLE (Id INT, UserId INT)
	Insert into @Table1(Id, UserId)
	SELECT		M.Id, M.UserId
	FROM		[dbo].[ApprovedMeeting] M WITH(NOLOCK)
	WHERE		M.MinuteSent = 0 and M.ActualEnd is not null and  DATEADD(HOUR, @TimeToBlockMinute, M.ActualEnd) < GETUTCDATE()

	Update m
	set MinuteSent = 1
	from dbo.Meeting m
		inner join @Table1 t on m.Id = t.Id
	
	select [Id], [UserId] from @Table1
END
