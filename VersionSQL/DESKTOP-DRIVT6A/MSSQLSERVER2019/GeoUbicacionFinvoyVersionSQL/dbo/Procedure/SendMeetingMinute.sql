/****** Object:  Procedure [dbo].[SendMeetingMinute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SendMeetingMinute]
   @Id INT
AS 
BEGIN
    SET NOCOUNT ON;
    UPDATE	[dbo].[Meeting]
	SET		[MinuteSent] = 1
	WHERE	[Id] = @Id
END
