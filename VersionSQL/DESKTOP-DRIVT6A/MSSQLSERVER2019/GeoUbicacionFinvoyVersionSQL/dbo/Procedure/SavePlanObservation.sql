/****** Object:  Procedure [dbo].[SavePlanObservation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SavePlanObservation]
    @WorkPlanId [sys].[INT] ,
    @ChangeReason [sys].VARCHAR(250)
AS
    BEGIN
        INSERT INTO dbo.PlanObservation
                ( IdWorkPlan ,
                  CreatedDate ,
                  Observation
                )
        VALUES  ( @WorkPlanId , -- IdWorkPlan - int
                  GETUTCDATE() , -- CreatedDate - datetime
                  @ChangeReason  -- Observation - varchar(250)
                )
    END;
