/****** Object:  ScalarFunction [dbo].[GetMeetingMinutesCount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[GetMeetingMinutesCount]
    (
      @MeetingId [sys].[INT] ,
      @RealCount [sys].[BIT]
    )
RETURNS [sys].INT
AS
    BEGIN
        DECLARE @Total [sys].INT;
        SET @Total = 0;
       
        ( SELECT    @Total = CASE WHEN @RealCount = 0
                                  THEN DATEDIFF(MINUTE, M.[Start], M.[End])
                                  ELSE DATEDIFF(MINUTE, M.[ActualStart],
                                                M.[ActualEnd])
                             END
          FROM      dbo.Meeting M
          WHERE     M.Id = @MeetingId
        );

        RETURN @Total;
    END;
