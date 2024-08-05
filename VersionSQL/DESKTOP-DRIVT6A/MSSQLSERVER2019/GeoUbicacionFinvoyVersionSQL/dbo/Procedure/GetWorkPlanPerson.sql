/****** Object:  Procedure [dbo].[GetWorkPlanPerson]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetWorkPlanPerson]
    @Id [sys].[INT] OUTPUT ,
    @IdPlan [sys].[INT]
AS
    BEGIN
        BEGIN 
            SELECT TOP 1
                    @Id = u.IdPersonOfInterest
            FROM    dbo.WorkPlan w
                    LEFT JOIN dbo.[User] u ON u.Id = w.IdUser
            WHERE   w.Id = @IdPlan;
        END;
    END;
