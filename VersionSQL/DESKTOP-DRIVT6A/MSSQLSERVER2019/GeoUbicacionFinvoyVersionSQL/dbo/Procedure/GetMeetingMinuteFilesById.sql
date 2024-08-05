/****** Object:  Procedure [dbo].[GetMeetingMinuteFilesById]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetMeetingMinuteFilesById] @Id [sys].[INT]
AS
    BEGIN
        SELECT  M.[Id], M.[Subject], M.[Start], M.[End], M.[UserId], M.[ActualStart], M.[ActualEnd],
				M.[Minute], M.[Deleted], M.[CreatedDate], M.[Description], M.[MicrosoftEventId],
				M.[MinuteSent], M.[MinuteFileName], M.[MinuteRealFileName], M.[MinuteFileEncoded],
				M.[SignaturesFileName], M.[SignaturesRealFileName], M.[SignaturesFileEncoded],
				M.[Synced], M.[SyncType], M.[IsFixed]
        FROM    [dbo].Meeting M
        WHERE   M.[Id] = @Id
    END;
