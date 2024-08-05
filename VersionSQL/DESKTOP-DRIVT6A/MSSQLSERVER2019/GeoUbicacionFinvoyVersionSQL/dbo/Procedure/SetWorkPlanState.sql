/****** Object:  Procedure [dbo].[SetWorkPlanState]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para cambiar el estado de un plan
-- =============================================
CREATE PROCEDURE [dbo].[SetWorkPlanState]
    @Id [sys].[INT] ,
    @ApprovedState [sys].[SMALLINT] ,
    @AppUserId [sys].[INT] ,
    @AppReason [sys].VARCHAR(250) = '' ,
    @TypeMeeting [sys].[INT] ,
    @TypeMeetingFixed [sys].[INT]
AS
    BEGIN
        DECLARE @StartPlan [sys].[DATETIME] ,
            @EndPlan [sys].[DATETIME]; 

        BEGIN 
            UPDATE  [dbo].WorkPlan
            SET     ApprovedState = @ApprovedState ,
                    ApprovingUserId = @AppUserId ,
                    ApprovedReason = @AppReason ,
                    ApprovedDate = GETUTCDATE()
            WHERE   Id = @Id;
        END;

        BEGIN
            IF ( @ApprovedState = 1 )
                BEGIN
		--Agrego las actividades que estan en el plan
                    INSERT  INTO dbo.WorkActivityPlanned
                            ( WorkPlanId ,
                              WorkActivityId ,
                              WorkActivityTypeId ,
                              PlannedDate ,
                              PlannedEndDate ,
                              PointOfInterestId ,
                              RoutePointOfInterestId ,
                              RouteGroupId ,
                              MeetingId
			                )
                            SELECT  @Id , -- WorkPlanId - int
                                    wa.Id , -- WorkActivityId - int
                                    wa.WorkActivityTypeId , -- WorkActivityTypeId - int
                                    wa.ActivityDate , -- PlannedDate - datetime
                                    wa.ActivityEndDate , -- PlannedEndDate - datetime
                                    wa.PointOfInterestId , -- PointOfInterestId - int
                                    wa.RoutePointOfInterestId , -- RoutePointOfInterestId - int
                                    wa.RouteGroupId , -- RouteGroupId - int
                                    wa.MeetingId -- MeetingId - int
                            FROM    dbo.WorkActivity wa
                            WHERE   wa.WorkPlanId = @Id
                                    AND wa.Deleted = 0;



                    SELECT  @StartPlan = wp.StartDate ,
                            @EndPlan = DATEADD(DAY, 1, wp.EndDate)
                    FROM    dbo.WorkPlan wp
                    WHERE   wp.Id = @Id;
			

			--Agrego las reuniones, que no tienen WA en el plan, pero si van a quedar en WAP
                    INSERT  INTO dbo.WorkActivityPlanned
                            ( WorkPlanId ,
                     -- WorkActivityId ,
                              WorkActivityTypeId ,
                              PlannedDate ,
                              PlannedEndDate ,
                              MeetingId
			                )
                            SELECT  @Id , -- WorkPlanId - int
                           -- wa.Id , -- WorkActivityId - int
                                    CASE WHEN m.IsFixed IS NOT NULL
                                              AND m.IsFixed = 1
                                         THEN @TypeMeetingFixed
                                         ELSE @TypeMeeting
                                    END , -- WorkActivityTypeId - int
                                    m.[Start] , -- PlannedDate - datetime
                                    m.[End] , -- PlannedEndDate - datetime
                                    m.Id -- MeetingId - int
                            FROM    dbo.Meeting m
                            WHERE   m.UserId = @AppUserId
                                    AND m.[Start] BETWEEN @StartPlan AND @EndPlan
                                    AND m.Deleted = 0;	


                END;
        END;
    END;
