/****** Object:  Procedure [dbo].[WorkPlanValidDate]    Committed by VersionSQL https://www.versionsql.com ******/

/****** Object:  StoredProcedure [dbo].[SaveWorkPlan]    Script Date: 17/3/2017 14:35:00 ******/


-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para guardar un plan
-- =============================================
CREATE PROCEDURE [dbo].[WorkPlanValidDate]
    @IdUser [sys].[INT] ,
    @StartDate [sys].[DATETIME] ,
    @EndDate [sys].[DATETIME]
AS
    BEGIN
        SELECT  COUNT(1) AS cant
        FROM    dbo.WorkPlan P
        WHERE   P.Deleted = 0
                AND ( P.ApprovedState = 3 --pending
                      OR P.ApprovedState = 1 -- approved
                    )
                AND P.IdUser = @IdUser
                AND ( ( @StartDate BETWEEN P.StartDate AND P.EndDate )
                      OR ( @EndDate BETWEEN P.StartDate AND P.EndDate )
                    );
    END;
