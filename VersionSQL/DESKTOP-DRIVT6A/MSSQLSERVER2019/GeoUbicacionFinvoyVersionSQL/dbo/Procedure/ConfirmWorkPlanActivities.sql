/****** Object:  Procedure [dbo].[ConfirmWorkPlanActivities]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para guardar un plan
-- =============================================
CREATE PROCEDURE [dbo].[ConfirmWorkPlanActivities]
    @PlanId [sys].[INT] ,
    @Start [sys].[DATETIME] ,
    @End [sys].[DATETIME]
AS
    BEGIN
        BEGIN 
            UPDATE  [dbo].WorkActivity
            SET     Confirmed = 1
            WHERE   WorkPlanId = @PlanId
                    AND ActivityDate BETWEEN @Start AND @End;

            DECLARE @ActivityType INT;
            DECLARE @ActivityDate DATETIME;

            DECLARE MY_CURSOR CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY
            FOR
                SELECT  WorkActivityTypeId ,
                        ActivityDate
                FROM    dbo.WorkActivity
                WHERE   WorkPlanId = @PlanId
                        AND ActivityDate BETWEEN @Start AND @End
                        AND Confirmed = 1;

            OPEN MY_CURSOR;
            FETCH NEXT FROM MY_CURSOR INTO @ActivityType, @ActivityDate;
            WHILE @@FETCH_STATUS = 0
                BEGIN 
                    UPDATE  dbo.WorkActivityPlanned
                    SET     Completed = 1
                    WHERE   Id IN (
                            SELECT TOP 1
                                    Id
                            FROM    dbo.WorkActivityPlanned
                            WHERE   WorkPlanId = @PlanId
                                    AND PlannedDate = @ActivityDate
                                    AND WorkActivityTypeId = @ActivityType
                                    AND Completed != 1 );
			


                    FETCH NEXT FROM MY_CURSOR INTO @ActivityType,
                        @ActivityDate;
                END;
            CLOSE MY_CURSOR;
            DEALLOCATE MY_CURSOR;

            SELECT  dbo.GetWorkPlanCompletitionFunctionById(@PlanId) AS Completition;

        END;

    END;
