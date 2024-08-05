/****** Object:  Procedure [dbo].[GetMeetingsReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 28/09/2017
-- Description:	SP para obtener reporte de reuniones
-- =============================================
CREATE PROCEDURE [dbo].[GetMeetingsReport]
    @DateFrom [sys].[DATETIME] ,
    @DateTo [sys].[DATETIME] ,
	@IdUser [sys].[int]
AS
    BEGIN
        SELECT  M.UserId ,
                CONCAT(U.[Name], ' ', U.LastName) AS UserName ,
                COUNT(M.Id) AS MeetingsCount ,
                SUM(dbo.GetMeetingMinutesCount(M.Id, 0)) AS MeetingMinutesCount ,
                SUM(dbo.GetMeetingMinutesCount(M.Id, 1)) AS MeetingMinutesRealCount ,
				SUM(dbo.GetMeetingGuestsCount(M.Id, 0)) AS MeetingGuestsCount ,
                SUM(dbo.GetMeetingGuestsCount(M.Id, 1)) AS MeetingGuestsRealCount
        FROM    dbo.ApprovedMeeting M
                INNER JOIN dbo.[User] U ON U.Id = M.UserId
        WHERE   U.[Status] = 'H'
                AND M.[ActualStart] BETWEEN @DateFrom AND @DateTo
                AND M.ActualEnd IS NOT NULL
				AND (@IdUser = U.Id OR (U.IdPersonOfInterest IS NOT NULL AND dbo.CheckUserInPersonOfInterestZones(U.IdPersonOfInterest, @IdUser) = 1))
        GROUP BY M.UserId ,
                CONCAT(U.[Name], ' ', U.LastName)
        ORDER BY CONCAT(U.[Name], ' ', U.LastName) ASC;
    END;
