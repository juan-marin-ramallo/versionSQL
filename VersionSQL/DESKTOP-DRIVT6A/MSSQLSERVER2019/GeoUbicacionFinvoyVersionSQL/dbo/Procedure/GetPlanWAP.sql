/****** Object:  Procedure [dbo].[GetPlanWAP]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		NR
-- Create date: 10/03/2017
-- Description:	SP para obtener las WA de un plan
-- =============================================
CREATE PROCEDURE [dbo].[GetPlanWAP] ( @IdPlan [sys].[INT], @TypeId [sys].[INT] )
AS
    BEGIN

        SELECT  wa.[Id], wa.[WorkPlanId], wa.[WorkActivityTypeId], wa.[PlannedDate], wa.[PlannedEndDate],
				wa.[PointOfInterestId], wa.[RouteGroupId], wa.[MeetingId], wa.[Completed],
				wa.[RoutePointOfInterestId], wa.[WorkActivityId],
                POI.Identifier AS POIIdentifier ,
                POI.[Name] AS PointOfInterestName ,
                rg.[Name] AS RouteGroupName ,
                m.[Subject] AS MeetingSubject ,
				m.[Description] AS MeetingDescription,
                p.[Name] AS ActivityType,
				waa.Description
        FROM    [dbo].WorkActivityPlanned wa
                INNER JOIN dbo.Parameter p ON p.[Value] = wa.WorkActivityTypeId
				LEFT JOIN dbo.WorkActivity waa ON wa.WorkActivityId = waa.id
                LEFT JOIN dbo.PointOfInterest POI ON POI.Id = wa.PointOfInterestId
                LEFT JOIN dbo.RouteGroup rg ON rg.Id = wa.RouteGroupId
                LEFT JOIN dbo.Meeting m ON m.Id = wa.MeetingId
        WHERE   wa.WorkPlanId = @IdPlan
                AND p.IdType = @TypeId;
	
    END;
