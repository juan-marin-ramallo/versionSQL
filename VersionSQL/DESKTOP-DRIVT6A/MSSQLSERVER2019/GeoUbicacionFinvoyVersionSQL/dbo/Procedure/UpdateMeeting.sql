/****** Object:  Procedure [dbo].[UpdateMeeting]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para guardar un plan
-- =============================================
CREATE PROCEDURE [dbo].[UpdateMeeting]
    @Id [sys].[INT] ,
    @ActivityDate [sys].[DATETIME] ,
    @ActivityEndDate [sys].[DATETIME] = NULL 

AS
BEGIN
    Update [dbo].Meeting
    set [Start] = @ActivityDate,
		[End] = @ActivityEndDate,
		[Synced] = 0,
		[SyncType] = 1 -- Outlook Event
    where Id = @Id

	select MicrosoftEventId 
	from dbo.Meeting
	where Id = @Id
END;
