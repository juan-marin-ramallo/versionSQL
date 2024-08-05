/****** Object:  Procedure [dbo].[GetWorkPlansFormsReportByUser]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Matias Corso
-- Create date: 14/11/2017
-- Description:	SP para obtener reporte de formularios por fecha para indicadores de agendas por usuario
-- =============================================
CREATE PROCEDURE [dbo].[GetWorkPlansFormsReportByUser]
    @DateFrom [sys].[DATETIME] ,
    @DateTo [sys].[DATETIME] ,
    @UserId IdTableType Readonly,
    @ActivityVisitDirectId [sys].[INT] = 0 , --Visitas Directas
    @ActivityVisitIndirectId [sys].[INT] = 0 --Visitas Indirectas
AS
BEGIN
    --DECLARE @PersonId [INT];
    --SELECT TOP 1
    --        @PersonId = IdPersonOfInterest
    --FROM    [User]
    --WHERE   Id = @UserId;

    --IF @PersonId IS NOT NULL
    --    BEGIN
                
            DECLARE @FormsCompletedCount TABLE
                (				
					[UserId] [sys].[INT],
                    [FormsDate] [sys].DATE ,
                    [CompletedForms] [sys].[INT]
                );

            INSERT  INTO @FormsCompletedCount
                    SELECT  U.Id AS UserId,
							Tzdb.ToUtc(CAST(Tzdb.FromUtc(CF.[Date]) AS DATE)) AS FormsDate ,
                            COUNT(CF.[Id]) AS CompletedForms --Formularios Completados
                    FROM    CompletedForm CF
						INNER JOIN [dbo].[User] U ON U.IdPersonOfInterest = CF.IdPersonOfInterest
						INNER JOIN @UserId IDU ON IDU.Id = U.Id
                    WHERE   --CAST(CF.[Date] AS DATE) >= CAST(@DateFrom AS DATE)
							Tzdb.IsGreaterOrSameSystemDate(CF.[Date], @DateFrom) = 1
                            --AND CAST(CF.[Date] AS DATE) <= CAST(@DateTo AS DATE)
							AND Tzdb.IsLowerOrSameSystemDate(CF.[Date], @DateTo) = 1
                    GROUP BY U.Id, Tzdb.ToUtc(CAST(Tzdb.FromUtc(CF.[Date]) AS DATE))
                    ORDER BY Tzdb.ToUtc(CAST(Tzdb.FromUtc(CF.[Date]) AS DATE));

            DECLARE @VisitsPlannedCount TABLE
                (
					[UserId] [sys].[INT],
                    [VisitsDate] [sys].DATE ,
                    [VisitDirectPlanned] [sys].[INT] ,
                    [VisitIndirectPlanned] [sys].[INT]
                );

            INSERT  INTO @VisitsPlannedCount
                    SELECT  U.Id,
							Tzdb.ToUtc(CAST(Tzdb.FromUtc(WAP.PlannedDate) AS DATE)) AS VisitsDate ,
                            SUM(CASE WHEN WAP.WorkActivityTypeId = @ActivityVisitDirectId
                                            AND WP.ApprovedState = 1 THEN 1
                                        ELSE 0
                                END) AS VisitDirectPlanned , --Visitas Directas Planificadas
                            SUM(CASE WHEN WAP.WorkActivityTypeId = @ActivityVisitIndirectId
                                            AND WP.ApprovedState = 1 THEN 1
                                        ELSE 0
                                END) AS VisitIndirectPlanned --Visitas Indirectas Planificadas
                    FROM    dbo.WorkActivityPlanned WAP
                            INNER JOIN dbo.WorkPlan WP ON WP.Id = WAP.WorkPlanId
                            INNER JOIN dbo.[User] U ON U.Id = WP.IdUser
							INNER JOIN @UserId IDU ON IDU.Id = U.Id
                    WHERE   WAP.PlannedDate BETWEEN @DateFrom AND @DateTo
							AND (WAP.WorkActivityTypeId = @ActivityVisitDirectId OR WAP.WorkActivityTypeId = @ActivityVisitIndirectId)
                    GROUP BY U.Id, Tzdb.ToUtc(CAST(Tzdb.FromUtc(WAP.PlannedDate) AS DATE))
                    ORDER BY Tzdb.ToUtc(CAST(Tzdb.FromUtc(WAP.PlannedDate) AS DATE));

            SELECT U.[Name] AS UserName, U.[LastName] AS UserLastName,
					( CASE WHEN FC.FormsDate IS NOT NULL THEN FC.FormsDate
                            ELSE VP.VisitsDate
                        END ) AS FormsDate ,
                    FC.CompletedForms ,
                    VP.VisitDirectPlanned ,
                    VP.VisitIndirectPlanned
            FROM    @FormsCompletedCount FC
                    FULL OUTER JOIN @VisitsPlannedCount VP ON VP.UserId = FC.UserId AND VP.VisitsDate = FC.FormsDate
					INNER JOIN [dbo].[User] U ON (VP.UserId IS NOT NULL AND VP.UserId = U.Id) OR (FC.UserId IS NOT NULL AND FC.UserId = U.Id)
            ORDER BY U.[Name] ASC, U.LastName ASC, ( CASE WHEN FC.FormsDate IS NOT NULL THEN FC.FormsDate
                            ELSE VP.VisitsDate
                        END );
        --END;
END;
