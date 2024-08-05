/****** Object:  Procedure [dbo].[SaveWorkActivity]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para guardar un plan
-- =============================================
CREATE PROCEDURE [dbo].[SaveWorkActivity]
    @Id [sys].[INT] OUTPUT ,
    @WPId [sys].[INT] ,
    @ActivityDate [sys].[DATETIME] ,
    @ActivityEndDate [sys].[DATETIME] = NULL ,
    @PointOfInterestId [sys].[INT] = NULL ,
    @RouteGroupId [sys].[INT] = NULL ,
    @MeetingId [sys].[INT] = NULL ,
    @Description [sys].[VARCHAR](2048) = NULL ,
    @WATypeId [sys].[INT] ,
    @Confirmed [sys].BIT
AS
    BEGIN

        BEGIN 
            INSERT  INTO [dbo].WorkActivity
                    ( WorkPlanId,
                      WorkActivityTypeId,
                      ActivityDate,
                      ActivityEndDate,
                      PointOfInterestId,
                      RouteGroupId,
                      MeetingId,
					  [Description],
                      [Deleted],
                      Confirmed,
					  [Synced],
					  [SyncType]
				    )
            VALUES  ( @WPId, -- id int
                      @WATypeId,
                      @ActivityDate,
                      @ActivityEndDate,
                      @PointOfInterestId,
                      @RouteGroupId,
                      @MeetingId,
					  @Description,
                      0,  -- Deleted - bit
                      @Confirmed,
					  0,
					  1 -- Outlook Event
				    );

            SELECT  @Id = SCOPE_IDENTITY();
        END;

    END;
