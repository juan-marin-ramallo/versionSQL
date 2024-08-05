/****** Object:  Procedure [dbo].[GetWorkPlansMeetingReportByUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 28/09/2017
-- Description:	SP para obtener reporte de reuniones de agendas por usuario
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkPlansMeetingReportByUser]
    @DateFrom [sys].[DATETIME] ,
    @DateTo [sys].[DATETIME] ,
    @UserId IdTableType Readonly,
    @ActivityMeetingId [sys].[INT] = 0 , --Reuniones
    @ActivityMeetingFixedId [sys].[INT] = 0 --Reuniones Fijas
AS
    BEGIN
        SELECT  M.Id AS MeetingId ,
				CONCAT(HOST.[Name], ' ', HOST.[LastName]) AS MeetingHost ,
                M.[Subject] AS MeetingSubject ,
                M.[Description] AS MeetingDescription ,
                M.[Minute] AS MeetingMinute ,
                M.[Start] AS [Start] ,
                M.[End] AS [End] ,
                M.[ActualStart] AS ActualStart ,
                M.[ActualEnd] AS ActualEnd ,
                M.IsFixed,
                M.[MinuteRealFileName] AS MinuteRealFileName ,
                M.[SignaturesRealFileName] AS SignaturesRealFileName ,
				CASE WHEN HOST.Id = U.Id THEN 1 ELSE 0 END AS UserIsHost ,
				CASE WHEN HOST.Id = U.Id OR (MG.Attended IS NOT NULL AND MG.Attended = 1) THEN 1 ELSE 0 END AS UserAttended ,
				CASE WHEN HOST.Id = U.Id OR (MG.CanEdit IS NOT NULL AND MG.CanEdit = 1) THEN 1 ELSE 0 END AS UserCanEdit,
				U.[Name] AS UserName, U.[LastName] AS UserLastName
        FROM    dbo.WorkPlan WP 
				INNER JOIN @UserId IDU ON WP.Iduser = IDU.Id
				INNER JOIN dbo.[User]  U ON IDU.Id = U.Id
                INNER JOIN dbo.WorkActivityPlanned WAP ON WP.Id = WAP.WorkPlanId
                INNER JOIN dbo.ApprovedMeeting M ON M.Id = WAP.MeetingId
				INNER JOIN dbo.[User] HOST ON HOST.Id = M.UserId
                LEFT JOIN dbo.MeetingGuest MG ON MG.MeetingId = M.Id
                                                 AND MG.UserId = U.Id
        WHERE   ( WAP.WorkActivityTypeId = @ActivityMeetingId
                  OR WAP.WorkActivityTypeId = @ActivityMeetingFixedId
                )
                AND WAP.PlannedDate BETWEEN @DateFrom AND @DateTo
		ORDER BY U.[Name] ASC, U.LastName ASC, WP.Id desc, WAP.Id asc
    END;
