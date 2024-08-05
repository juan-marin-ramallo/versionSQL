/****** Object:  Procedure [dbo].[GetWorkPlansPendingApproval]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para obtener un plan segun POI
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkPlansPendingApproval]
(
	@UserId [sys].[int]
)
AS
BEGIN

	SELECT	wp.[Id], wp.[StartDate], wp.[EndDate], wp.[ApprovedState], wp.[ApprovingUserId], wp.[ApprovedDate],
			wp.[ApprovedReason], wp.[IdUser], wp.[CreationDate], wp.[Deleted], wp.[IdRouteGroup],
			u.[Name] AS UserName, u.LastName AS UserLastName 

	FROM	[dbo].WorkPlan wp
	INNER JOIN dbo.[User] u ON u.Id = wp.IdUser

	WHERE	wp.Deleted = 0 AND
			wp.ApprovedState = 3 --pending approval
	ORDER BY wp.StartDate DESC, wp.CreationDate DESC
END
