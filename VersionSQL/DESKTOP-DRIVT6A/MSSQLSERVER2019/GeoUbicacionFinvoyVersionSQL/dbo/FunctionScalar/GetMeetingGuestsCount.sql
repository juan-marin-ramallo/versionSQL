/****** Object:  ScalarFunction [dbo].[GetMeetingGuestsCount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[GetMeetingGuestsCount]
    (
      @MeetingId [sys].[INT] ,
      @AssistanceCount [sys].[BIT]
    )
RETURNS [sys].INT
AS
    BEGIN
        DECLARE @Total [sys].INT;
        SET @Total = 0;
       
        ( SELECT    @Total = COUNT(CASE WHEN @AssistanceCount = 0 THEN 1
                                        ELSE ( CASE WHEN MG.Attended = 1
                                                    THEN 1
                                                    ELSE NULL
                                               END )
                                   END)
          FROM      dbo.MeetingGuest MG
          WHERE     MG.MeetingId = @MeetingId
                    AND MG.Deleted = 0
        );

        RETURN @Total;
    END;
