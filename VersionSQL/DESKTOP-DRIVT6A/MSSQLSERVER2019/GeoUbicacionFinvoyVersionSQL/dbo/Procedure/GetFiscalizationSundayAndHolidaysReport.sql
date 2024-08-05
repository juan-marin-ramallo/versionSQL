/****** Object:  Procedure [dbo].[GetFiscalizationSundayAndHolidaysReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 28/08/2023
-- Description:	SP para obtener los datos para
--              el reporte de fiscalización
--              de domingos y feriados
--              trabajados por las personas de
--              interés
-- =============================================
CREATE PROCEDURE [dbo].[GetFiscalizationSundayAndHolidaysReport]
(
     @PersonOfInterestIds [sys].[varchar](MAX) = NULL
    ,@WorkShiftIds [sys].[varchar](MAX) = NULL
    ,@PlaceOfWorkIds [sys].[varchar](MAX) = NULL
    ,@PersonOfInterestTypeCodes [sys].[varchar](MAX) = NULL
    ,@DateFrom [sys].[datetime]
    ,@DateTo [sys].[datetime]
)
AS
BEGIN
    DECLARE @DateFromSystem [sys].[datetime] = Tzdb.FromUtc(@DateFrom)
    DECLARE @DateToSystem [sys].[datetime] = Tzdb.FromUtc(@DateTo)

    CREATE TABLE #SundaysAndHolidays
    (
         [IdPersonOfInterest] [sys].[int]
        ,[Date] [sys].[datetime]
        ,[DateSystem] [sys].[datetime]
    );

    WITH DateRange AS (
        SELECT @DateFromSystem AS [Date]
        UNION ALL
        SELECT DATEADD(DAY, 1, [Date])
        FROM DateRange
        WHERE [Date] < @DateToSystem
    ),
    Persons AS (
        SELECT  [Id]--, [Name], [LastName], [Identifier]
        FROM    [dbo].[PersonOfInterest] WITH (NOLOCK)
        WHERE   (@PersonOfInterestIds IS NULL OR dbo.[CheckValueInList]([Id], @PersonOfInterestIds) = 1)
    )

    -- Sundays and holidays
    INSERT INTO #SundaysAndHolidays([IdPersonOfInterest], [Date], [DateSystem])
    SELECT  P.[Id], Tzdb.ToUtc(DR.[Date]), DR.[Date]
    FROM    DateRange DR
            CROSS JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK)
            INNER JOIN [dbo].[PersonOfInterestFiscalizationInfo] PFI WITH (NOLOCK) ON PFI.[IdPersonOfInterest] = P.[Id] AND PFI.[CreatedDate] <= Tzdb.ToUtc(DR.[Date])
    WHERE   DATEPART(WEEKDAY, DR.[Date]) = 1
            AND P.[Deleted] = 0
            AND P.[Pending] = 0
            AND P.[Status] = 'H'

    UNION

    SELECT  P.[Id], Tzdb.ToUtc(WH.[Date]), WH.[Date]
    FROM    [WorkHoliday] WH
            CROSS JOIN [dbo].[PersonOfInterest] P WITH (NOLOCK)
            INNER JOIN [dbo].[PersonOfInterestFiscalizationInfo] PFI WITH (NOLOCK) ON PFI.[IdPersonOfInterest] = P.[Id] AND PFI.[CreatedDate] <= Tzdb.ToUtc(WH.[Date])
    WHERE   [Date] BETWEEN @DateFromSystem AND @DateToSystem
            AND P.[Deleted] = 0
            AND P.[Pending] = 0
            AND P.[Status] = 'H'
    
    ORDER BY    P.[Id], DR.[Date]

    OPTION  (MAXRECURSION 0);

    WITH PersonsMarks AS (
        SELECT  [IdPersonOfInterest], DATEADD(DD, DATEDIFF(DD, 0, Tzdb.FromUtc([Date])), 0) AS DateSystem
        FROM    [dbo].[Mark] WITH (NOLOCK)
        WHERE   [Date] BETWEEN @DateFrom AND Tzdb.ToUtc(DATEADD(DAY, 1, Tzdb.FromUtc(@DateTo)))
                AND (@PersonOfInterestIds IS NULL OR dbo.[CheckValueInList]([IdPersonOfInterest], @PersonOfInterestIds) = 1)
    )

    SELECT      P.[Id] AS IdPersonOfInterest, P.[Name] AS PersonOfInterestName, P.[LastName] AS PersonOfInterestLastName, P.[Identifier] AS PersonOfInterestIdentifier,
                PFI.[WorkOnSundays] AS PersonOfInterestWorkOnSundays,
                SH.[Date], (CASE WHEN PM.[IdPersonOfInterest] IS NULL THEN 0 ELSE 1 END) AS Attended, (CASE WHEN PM.[IdPersonOfInterest] IS NULL THEN (CASE WHEN PA.[Id] IS NULL THEN 2 ELSE 1 END) ELSE 0 END) AS Absence,
                ABR.[Name] + (CASE WHEN PA.[Comments] IS NULL THEN '' ELSE ': ' + PA.[Comments] END) AS Observations
    FROM        [dbo].[PersonOfInterest] P WITH (NOLOCK)
                INNER JOIN [dbo].[PersonOfInterestFiscalizationInfo] PFI WITH (NOLOCK) ON PFI.[IdPersonOfInterest] = P.[Id]
                LEFT OUTER JOIN #SundaysAndHolidays SH ON SH.[IdPersonOfInterest] = P.[Id] AND PFI.[WorkOnSundays] = 1
                --LEFT OUTER JOIN [dbo].[Mark] M WITH (NOLOCK) ON M.[IdPersonOfInterest] = P.[Id] AND M.[Date] BETWEEN SH.[Date] AND DATEADD(DAY, 1, SH.[Date]) -- Same day
                LEFT OUTER JOIN PersonsMarks PM ON PM.[IdPersonOfInterest] = P.[Id] AND PM.[DateSystem] = SH.[DateSystem]
                LEFT OUTER JOIN [dbo].[PersonOfInterestWorkShift] PWS WITH (NOLOCK) ON PWS.[IdPersonOfInterest] = P.[Id] AND PWS.[IdDayOfWeek] = DATEPART(WEEKDAY, SH.[DateSystem])
                LEFT OUTER JOIN [dbo].[PersonOfInterestAbsence] PA WITH (NOLOCK) ON PA.[IdPersonOfInterest] = P.[Id] AND PA.[FromDate] = SH.[Date]
                LEFT OUTER JOIN [dbo].[AbsenceReason] ABR WITH (NOLOCK) ON ABR.[Id] = PA.[IdAbsenceReason]
    WHERE       --(M.[Id] IS NULL OR (M.[Date] BETWEEN @DateFrom AND @DateTo))
                (@PersonOfInterestIds IS NULL OR dbo.[CheckValueInList](P.[Id], @PersonOfInterestIds) = 1)
                AND (@WorkShiftIds IS NULL OR dbo.[CheckValueInList](PWS.[IdWorkShift], @WorkShiftIds) = 1)
                AND (@PlaceOfWorkIds IS NULL OR dbo.[CheckValueInList](PFI.[IdPlaceOfWork], @PlaceOfWorkIds) = 1)
                AND (@PersonOfInterestTypeCodes IS NULL OR dbo.[CheckCharValueInList](P.[Type], @PersonOfInterestTypeCodes) = 1)
                AND P.[Deleted] = 0
                AND P.[Pending] = 0
                AND P.[Status] = 'H'
    GROUP BY    P.[Id], P.[Name], P.[LastName], P.[Identifier],
                PFI.[WorkOnSundays], SH.[Date], PM.[IdPersonOfInterest],
                PA.[Id], PA.[Comments], ABR.[Name]
    ORDER BY    P.[Name], P.[LastName], SH.[Date];
    
    DROP TABLE #SundaysAndHolidays;
END
