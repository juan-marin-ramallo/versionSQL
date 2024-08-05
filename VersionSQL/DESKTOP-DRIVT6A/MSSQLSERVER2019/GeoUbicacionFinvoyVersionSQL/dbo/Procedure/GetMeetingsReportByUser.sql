/****** Object:  Procedure [dbo].[GetMeetingsReportByUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 28/09/2017
-- Description:	SP para obtener reporte de reuniones por usuario
-- =============================================
CREATE PROCEDURE [dbo].[GetMeetingsReportByUser]
    @DateFrom [sys].[DATETIME] ,
    @DateTo [sys].[DATETIME] ,
    @UserId IdTableType Readonly
AS
    BEGIN
        SELECT  M.Id AS MeetingId ,
                CONCAT(U.[Name], ' ', U.[LastName]) AS MeetingHost ,
                M.[Subject] AS MeetingSubject ,
                M.[Description] AS MeetingDescription ,
                M.[Minute] AS MeetingMinute ,
                M.[Start] AS [Start] ,
                M.[End] AS [End] ,
                M.[ActualStart] AS ActualStart ,
                M.[ActualEnd] AS ActualEnd ,
                DATEDIFF(MINUTE, M.[Start], M.[End]) AS MeetingMinutesCount ,
                DATEDIFF(MINUTE, M.[ActualStart], M.[ActualEnd]) AS MeetingMinutesRealCount ,
                COUNT(MG.Id) AS MeetingGuestsCount ,
                COUNT(CASE WHEN MG.Attended = 1 THEN 1
                           ELSE NULL
                      END) AS MeetingGuestsRealCount ,
                M.[MinuteRealFileName] AS MinuteRealFileName ,
                M.[SignaturesRealFileName] AS SignaturesRealFileName ,
                M.IsFixed
        FROM    dbo.ApprovedMeeting M
				INNER JOIN @UserId IDU ON M.UserId = IDU.Id
                INNER JOIN dbo.MeetingGuest MG ON MG.MeetingId = M.Id
                INNER JOIN dbo.[User] U ON U.Id = M.UserId
        WHERE   U.[Status] = 'H'
                AND M.[ActualStart] BETWEEN @DateFrom AND @DateTo
                AND M.ActualEnd IS NOT NULL
        GROUP BY M.Id ,
                CONCAT(U.[Name], ' ', U.[LastName]) ,
                M.[Subject] ,
                M.[Description] ,
                M.[Minute] ,
                M.[Start] ,
                M.[End] ,
                M.[ActualStart] ,
                M.[ActualEnd] ,
                DATEDIFF(HOUR, M.[Start], M.[End]) ,
                DATEDIFF(HOUR, M.[ActualStart], M.[ActualEnd]) ,
                M.[MinuteRealFileName] ,
                M.[SignaturesRealFileName] ,
				M.IsFixed
        ORDER BY CONCAT(U.[Name], ' ', U.[LastName]) ASC, [Start] DESC;
    END;
