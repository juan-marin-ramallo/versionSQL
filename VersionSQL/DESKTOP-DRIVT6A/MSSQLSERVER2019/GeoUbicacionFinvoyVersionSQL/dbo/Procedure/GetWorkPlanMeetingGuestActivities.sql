/****** Object:  Procedure [dbo].[GetWorkPlanMeetingGuestActivities]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 21/08/2017
-- Description:	--
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkPlanMeetingGuestActivities]
    (
      @IdUser [sys].[INT] ,
      @DateFrom [sys].DATETIME ,
      @DateTo [sys].DATETIME
  
    )
AS
    BEGIN

        SELECT  m.[Start] AS ActivityDate ,
                m.[End] AS ActivityEndDate ,
                m.[Subject] AS MeetingSubject ,
				m.[Description] AS MeetingDescription,
                m.Id AS MeetingId ,
				m.IsFixed
        FROM    dbo.ApprovedMeeting m
                INNER JOIN dbo.MeetingGuest mg ON mg.MeetingId = m.Id
                                                  AND mg.UserId = @IdUser
        WHERE   m.UserId <> @IdUser
                AND mg.Deleted = 0
                AND m.[Start] BETWEEN @DateFrom AND @DateTo; 

    END;
