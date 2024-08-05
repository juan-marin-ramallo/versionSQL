/****** Object:  Procedure [dbo].[UpdateMeetingDescription]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[UpdateMeetingDescription]
   @Id INT,
   @Desc NVARCHAR(MAX)
AS 
BEGIN
    SET NOCOUNT ON;
    UPDATE	[dbo].[Meeting]
	SET		[Description] = @Desc,
			[Synced] = 0,
			[SyncType] = 3 -- Outlook Description
	WHERE	[Id] = @Id
END
