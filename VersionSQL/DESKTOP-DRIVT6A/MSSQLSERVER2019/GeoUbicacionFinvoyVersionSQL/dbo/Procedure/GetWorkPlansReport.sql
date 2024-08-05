/****** Object:  Procedure [dbo].[GetWorkPlansReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:  Matias Corso  
-- Create date: 28/09/2017  
-- Description: SP para obtener reporte de agendas  
-- =============================================  
CREATE PROCEDURE [dbo].[GetWorkPlansReport]  
    @DateFrom [sys].[DATETIME] ,  
    @DateTo [sys].[DATETIME] ,  
    @ActivityMeetingId [sys].[INT] = 0 , --Reuniones  
    @ActivityMeetingFixedId [sys].[INT] = 0 , --Reuniones Fijas  
    @ActivityVisitDirectId [sys].[INT] = 0 , --Visitas Directas  
    @ActivityVisitIndirectId [sys].[INT] = 0 , --Visitas Indirectas  
 @IdUser [sys].[INT]  
AS  
    BEGIN  
  
        DECLARE @RoutesCount TABLE  
            (  
              [PersonOfInterestId] [sys].[INT] ,  
              [TotalVisitedDirect] [sys].[INT] ,  
              [TotalVisitedIndirect] [sys].[INT]  
            );  
    
        INSERT  INTO @RoutesCount  
                SELECT  PersonOfInterestId ,  
                        SUM(CASE WHEN RouteStatus = 1  
                                      AND ActivityVisitTypeId IS NOT NULL  
                                      AND ActivityVisitTypeId = @ActivityVisitDirectId  
                                 THEN 1  
                                 ELSE 0  
                            END) AS TotalVisitedDirect ,  
                        SUM(CASE WHEN RouteStatus = 1  
                                      AND ActivityVisitTypeId IS NOT NULL  
                                      AND ActivityVisitTypeId = @ActivityVisitIndirectId  
                                 THEN 1  
                                 ELSE 0  
                            END) AS TotalVisitedIndirect  
                FROM    [dbo].[RoutesReportFiltered](@DateFrom, @DateTo, NULL,  
                                                     NULL, NULL, NULL, NULL,  
                                                     DEFAULT, NULL, 1)  
                GROUP BY PersonOfInterestId;  
  
        DECLARE @FormsCompletedCount TABLE  
            (  
              [PersonOfInterestId] [sys].[INT] ,  
              [TotalFormsCompleted] [sys].[INT]  
            );  
    
        INSERT  INTO @FormsCompletedCount  
                SELECT  CF.IdPersonOfInterest AS PersonOfInterestId ,  
                        COUNT(CF.[Id]) AS TotalFormsCompleted  
                FROM    CompletedForm CF  
                WHERE   --CAST(CF.[Date] AS DATE) >= CAST(@DateFrom AS DATE)  
      Tzdb.IsGreaterOrSameSystemDate(CF.[Date], @DateFrom) = 1  
                        --AND CAST(CF.[Date] AS DATE) <= CAST(@DateTo AS DATE)  
      AND Tzdb.IsLowerOrSameSystemDate(CF.[Date], @DateTo) = 1  
                GROUP BY CF.IdPersonOfInterest;  
  
        SELECT  U.Id AS UserId ,  
                CONCAT(U.[Name], ' ', U.LastName) AS UserName ,  
                SUM(CASE WHEN WAP.WorkActivityTypeId = @ActivityMeetingId  
                              OR WAP.WorkActivityTypeId = @ActivityMeetingFixedId  
                         THEN ( CASE WHEN M.ActualEnd IS NOT NULL  
                                          AND ( M.UserId = U.Id  
                                                OR ( MG.Attended IS NOT NULL  
                                                     AND MG.Attended = 1  
                                                   )  
                                              ) THEN 1  
                                     ELSE 0  
                                END )  
                         ELSE 0  
                    END) AS MeetingsDone , -- Reuniones Realizadas  
                SUM(CASE WHEN WAP.WorkActivityTypeId = @ActivityMeetingId  
                              OR WAP.WorkActivityTypeId = @ActivityMeetingFixedId  
                         THEN 1  
                         ELSE 0  
                    END) AS MeetingsPlanned , -- Reuniones Planificadas  
                CASE WHEN C.TotalVisitedDirect IS NULL THEN 0  
                     ELSE C.TotalVisitedDirect  
                END AS VisitDirectDone , -- Visitas Directas Relizadas  
                SUM(CASE WHEN WAP.WorkActivityTypeId = @ActivityVisitDirectId  
                              AND WP.ApprovedState = 1 THEN 1  
                         ELSE 0  
                    END) AS VisitDirectPlanned , --Visitas Directas Planificadas  
                CASE WHEN C.TotalVisitedIndirect IS NULL THEN 0  
                     ELSE C.TotalVisitedIndirect  
                END AS VisitIndirectDone , -- Visitas Indirectas Relizadas  
                SUM(CASE WHEN WAP.WorkActivityTypeId = @ActivityVisitIndirectId  
                              AND WP.ApprovedState = 1 THEN 1  
                         ELSE 0  
                    END) AS VisitIndirectPlanned , --Visitas Indirectas Planificadas  
                CASE WHEN FCC.TotalFormsCompleted IS NULL THEN 0  
                     ELSE FCC.TotalFormsCompleted  
                END AS CompletedForms -- Formularios Completados  
        FROM    dbo.WorkActivityPlanned WAP  
                INNER JOIN dbo.WorkPlan WP ON WP.Id = WAP.WorkPlanId  
                INNER JOIN dbo.[User] U ON U.Id = WP.IdUser  
                LEFT JOIN dbo.ApprovedMeeting M ON M.Id = WAP.MeetingId  
                LEFT JOIN dbo.MeetingGuest MG ON MG.MeetingId = M.Id  
                                                 AND MG.UserId = U.Id  
                LEFT JOIN @RoutesCount C ON C.PersonOfInterestId = U.IdPersonOfInterest  
                LEFT JOIN @FormsCompletedCount FCC ON FCC.PersonOfInterestId = U.IdPersonOfInterest  
        WHERE   WAP.PlannedDate BETWEEN @DateFrom AND @DateTo AND  
    (@IdUser = U.Id OR (U.IdPersonOfInterest IS NOT NULL AND dbo.CheckUserInPersonOfInterestZones(U.IdPersonOfInterest, @IdUser) = 1))  
        GROUP BY U.Id ,  
                CONCAT(U.[Name], ' ', U.LastName) ,  
                C.TotalVisitedDirect ,  
                C.TotalVisitedIndirect ,  
                FCC.TotalFormsCompleted  
  ORDER BY CONCAT(U.[Name], ' ', U.LastName) ASC  
    END;  
  
  
