/****** Object:  Procedure [dbo].[GetHasWorkActivitiesToSyncWithMicrosoft]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 01/11/2017
-- Description:	SP para saber si un usuario tiene WA de cualquier plan que estén pendientes de sincronización con Outlook
-- =============================================
CREATE PROCEDURE [dbo].[GetHasWorkActivitiesToSyncWithMicrosoft]
(
	@IdUser [sys].[int]
)
AS
BEGIN
    SELECT  TOP(1) 1
    FROM    [dbo].[WorkPlan] WP WITH (NOLOCK)
			INNER JOIN [dbo].[WorkActivity] WA WITH (NOLOCK) ON WA.[WorkPlanId] = WP.[Id]
    WHERE   WP.[IdUser] = @IdUser
			AND WP.[ApprovedState] = 1
			AND WA.[Synced] = 0

	UNION

	SELECT	TOP(1) 1
	FROM	[dbo].[ApprovedMeeting] M WITH (NOLOCK)
	WHERE	M.[UserId] = @IdUser
			AND M.[Synced] = 0
			
END
