/****** Object:  Procedure [dbo].[GetWorkActivitiesToSync]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		FS
-- Create date: 19/09/2017
-- Description:	SP para obtener las WA de una persona que deben sincronizarse
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkActivitiesToSync] ( @IdUser [sys].[int] )
AS
BEGIN
	DECLARE @LastWeek [sys].[DateTime] = Tzdb.ToUtc(DATEADD(week, -1,  CONVERT(date, Tzdb.FromUtc(GETUTCDATE()))))

    SELECT  wa.* ,
            POI.Identifier AS POIIdentifier ,
            POI.[Name] AS PointOfInterestName ,
            rg.[Name] AS RouteGroupName,
			m.[Subject] AS MeetingSubject,
			m.[Description] AS MeetingDescription,
            p.[Name] AS ActivityType
	FROM WorkPlan wp 
		INNER JOIN WorkActivity wa ON wp.Id = wa.WorkPlanId 
		INNER JOIN dbo.Parameter p ON p.[Value] = wa.WorkActivityTypeId
		LEFT JOIN dbo.PointOfInterest POI ON POI.Id = wa.PointOfInterestId
		LEFT JOIN dbo.RouteGroup rg ON rg.Id = wa.RouteGroupId
		LEFT JOIN Meeting m ON wa.MeetingId = m.Id AND wp.IdUser = m.UserId
	WHERE	wp.IdUser = @IdUser
			AND wa.MicrosoftEventId IS NULL
			AND wa.ActivityDate >= @LastWeek
			AND (	
				(wp.ApprovedState = 1 AND wp.Deleted = 0 AND wa.Deleted = 0)
				OR	(m.deleted = 0 
					AND NOT EXISTS (SELECT 1 
									FROM WorkActivity mwa 
										INNER JOIN WorkPlan mwp ON mwp.Id = mwa.WorkPlanId 
									WHERE m.id = mwa.MeetingId AND (mwp.ApprovedState = 1 AND mwp.Deleted = 0 AND mwa.Deleted = 0) ) 
					)
			)	
END;
