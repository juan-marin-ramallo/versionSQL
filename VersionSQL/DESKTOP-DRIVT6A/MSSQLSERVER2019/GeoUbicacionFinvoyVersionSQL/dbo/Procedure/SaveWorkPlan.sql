/****** Object:  Procedure [dbo].[SaveWorkPlan]    Committed by VersionSQL https://www.versionsql.com ******/

/****** Object:  StoredProcedure [dbo].[SaveWorkPlan]    Script Date: 17/3/2017 14:35:00 ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para guardar un plan
-- =============================================
CREATE PROCEDURE [dbo].[SaveWorkPlan]
     @Id [sys].[INT] OUTPUT
    ,@IdUser [sys].[INT]
    ,@StartDate [sys].[DATETIME]
    ,@EndDate [sys].[DATETIME] 
    ,@WorkActivities [WorkActivityTableType] READONLY
AS
BEGIN 
    INSERT  INTO [dbo].WorkPlan
            ( StartDate ,
                EndDate ,
                ApprovedState ,
                [CreationDate] ,
                [IdUser] ,
                [Deleted]
			)
            SELECT  @StartDate ,
                    @EndDate ,
                    2 ,
                    GETUTCDATE() ,
                    @IdUser ,
                    0;

    SELECT  @Id = SCOPE_IDENTITY();

	INSERT INTO dbo.WorkActivity
			( WorkPlanId,
			    WorkActivityTypeId,
			    ActivityDate,
			    ActivityEndDate,
			    PointOfInterestId,
			    RouteGroupId,
			    MeetingId,
				[Description],
			    Deleted,
			    Confirmed,
				Synced,
				SyncType
			)
			SELECT  @Id, -- WorkPlanId - int
                    WA.WorkActivityTypeId, -- WorkActivityTypeId - int
                    WA.ActivityDate, -- ActivityDate - datetime
                    WA.ActivityEndDate, -- ActivityEndDate - datetime
					CASE WHEN WA.PointOfInterestId = 0 THEN NULL
                            ELSE WA.PointOfInterestId -- PointOfInterestId - int
                    END,
                    CASE WHEN WA.RouteGroupId = 0 THEN NULL
                            ELSE WA.RouteGroupId -- RouteGroupId - int
                    END,
					CASE WHEN WA.MeetingId = 0 THEN NULL
                            ELSE WA.MeetingId -- MeetingId - int
                    END,
					WA.[Description],
                    0,
                    0,
					0,
					1 -- Outlook Event
            FROM    @WorkActivities WA;
END;
