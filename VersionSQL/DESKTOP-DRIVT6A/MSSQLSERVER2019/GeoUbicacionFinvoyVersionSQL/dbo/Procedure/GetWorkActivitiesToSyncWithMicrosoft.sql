/****** Object:  Procedure [dbo].[GetWorkActivitiesToSyncWithMicrosoft]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 01/11/2017
-- Description:	SP para obtener las WA de cualquier plan de un usuario dado que estén pendientes de sincronización con Outlook
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkActivitiesToSyncWithMicrosoft]
(
	@IdUser [sys].[int]
)
AS
BEGIN
    SELECT  WA.[Id], WA.[WorkPlanId], WA.[WorkActivityTypeId], WA.[ActivityDate], WA.[ActivityEndDate],
			WA.[PointOfInterestId], WA.[RouteGroupId], WA.[MeetingId], WA.[Deleted],
			WA.[MicrosoftEventId], WA.[Confirmed], WA.[RoutePointOfInterestId], 
			IIF(M.Id IS NULL, WA.[SyncType], M.[SyncType]) as [SyncType],
            POI.[Identifier] AS POIIdentifier,
            POI.[Name] AS PointOfInterestName,
            RG.[Name] AS RouteGroupName,
			M.[Subject] AS MeetingSubject,
			M.[Description] AS MeetingDescription,
            P.[Name] AS ActivityType
    FROM    [dbo].[WorkPlan] WP WITH (NOLOCK)
			INNER JOIN [dbo].[WorkActivity] WA WITH (NOLOCK) ON WA.[WorkPlanId] = WP.[Id]
            INNER JOIN [dbo].[Parameter] P WITH (NOLOCK) ON P.[Value] = WA.WorkActivityTypeId
            LEFT JOIN [dbo].[PointOfInterest] POI WITH (NOLOCK) ON POI.[Id] = WA.[PointOfInterestId]
            LEFT JOIN [dbo].[RouteGroup] RG WITH (NOLOCK) ON RG.[Id] = WA.[RouteGroupId]
			LEFT JOIN [dbo].[Meeting] M WITH (NOLOCK) ON M.[Id] = WA.[MeetingId]
    WHERE   WP.[IdUser] = @IdUser
			AND WP.Deleted = 0 AND WA.Deleted = 0
			AND WP.[ApprovedState] = 1
			AND WA.[Synced] = 0
END
