/****** Object:  Procedure [dbo].[GetWorkPlan]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 23/01/2018
-- Description:	SP para obtener un plan
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkPlan]
    (
      @Id [sys].[int]
    )
AS
    BEGIN

        SELECT  wp.[Id], wp.[StartDate], wp.[EndDate], wp.[ApprovedState], wp.[ApprovingUserId], wp.[ApprovedDate],
				wp.[ApprovedReason], wp.[IdUser], wp.[CreationDate], wp.[Deleted], wp.[IdRouteGroup],
                u.[IdPersonOfInterest] ,
                u.[Name] AS UserName ,
                u.LastName AS UserLastName ,
                dbo.GetWorkPlanCompletitionFunctionById(wp.Id) AS Completition
        FROM    [dbo].WorkPlan wp
                INNER JOIN dbo.[User] u ON u.Id = wp.IdUser
        WHERE   wp.Id = @Id
    END;
