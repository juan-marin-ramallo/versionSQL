/****** Object:  Procedure [dbo].[GetWorkPlanMeetingActivities]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 21/08/2017
-- Description:	--
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkPlanMeetingActivities]
    (
      @IdUser [sys].[INT] ,
      @DateFrom [sys].DATETIME ,
      @DateTo [sys].DATETIME
    )
AS
BEGIN
   SELECT  m.[Start] AS ActivityDate ,
                m.[End] AS ActivityEndDate ,
                m.[Subject] AS MeetingSubject,
				m.[Description] AS MeetingDescription,
                m.Id AS MeetingId ,
				m.MicrosoftEventId ,
				m.IsFixed
    FROM    dbo.Meeting m
		LEFT JOIN dbo.WorkActivity a ON a.MeetingId = m.Id
        LEFT JOIN dbo.WorkPlan p ON p.Id = a.WorkPlanId
    WHERE   m.Deleted = 0
            AND m.UserId = @IdUser
            AND m.[Start] BETWEEN @DateFrom AND @DateTo
			-- No pertenecen a una work activiti o pertenecen a algo borrado / rechazado
			AND (a.Id IS NULL OR (a.Deleted = 1 OR p.Deleted = 1 OR p.ApprovedState = 0)) 
END;
