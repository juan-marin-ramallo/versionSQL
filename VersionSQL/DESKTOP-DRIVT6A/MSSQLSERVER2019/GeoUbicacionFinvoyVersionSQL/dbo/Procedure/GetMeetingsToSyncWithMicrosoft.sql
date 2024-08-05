/****** Object:  Procedure [dbo].[GetMeetingsToSyncWithMicrosoft]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 01/11/2017
-- Description:	SP para obtener las meetings de un usuario dado que estén pendientes de sincronización con Outlook
-- =============================================
CREATE PROCEDURE [dbo].[GetMeetingsToSyncWithMicrosoft]
(
	@IdUser [sys].[int]
)
AS
BEGIN
    SELECT  [Start] AS ActivityDate, [End] AS ActivityEndDate, [Subject] AS MeetingSubject, [Description] AS MeetingDescription,
			[Id] AS MeetingId, [MicrosoftEventId], [SyncType]
    FROM    [dbo].[Meeting]
    WHERE   [UserId] = @IdUser
			AND [Synced] = 0
            AND [Id] NOT IN (
				SELECT	DISTINCT A.MeetingId
				FROM    [dbo].[WorkActivity] A
						INNER JOIN [dbo].[WorkPlan] WP ON WP.[Id] = A.[WorkPlanId]
				WHERE   A.[Deleted] = 0
						AND A.[MeetingId] IS NOT NULL
						AND (WP.[ApprovedState] <> 0 OR WP.[ApprovedState] IS NULL) AND WP.[Deleted] = 0);
END
