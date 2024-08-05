/****** Object:  Procedure [dbo].[AddGuestsToMeeting]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[AddGuestsToMeeting]
    @MeetingId INT ,
    @GuestsIds NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT  INTO dbo.MeetingGuest
            ( MeetingId,
                UserId,
                CanEdit,
                Deleted,
                Attended,
                CreatedDate
	        )
            SELECT  @MeetingId,
                    U.Id,
                    0,
                    0,
                    CASE WHEN M.ActualStart IS NOT NULL THEN 0
                            ELSE NULL
                    END,
                    GETUTCDATE()
            FROM    dbo.[User] U
                    INNER JOIN dbo.Meeting M ON M.Id = @MeetingId
            WHERE   @GuestsIds IS NOT NULL
                    AND dbo.CheckValueInList(U.[Id], @GuestsIds) > 0;

	UPDATE	[dbo].[Meeting]
	SET		[Synced] = 0,
			[SyncType] = 2 -- Outlook Guests
	WHERE	[Id] = @MeetingId
END
