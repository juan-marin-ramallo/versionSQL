/****** Object:  Procedure [dbo].[GetFiscalizationDailyReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Jesús Portillo
-- Create date: 30/08/2023
-- Description:	SP para obtener los datos para
--              el reporte de fiscalización
--              de jornada diaria de las
--              personas de interés
-- =============================================
CREATE PROCEDURE [dbo].[GetFiscalizationDailyReport]
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

    CREATE TABLE #PersonDates
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
        SELECT  [Id]
        FROM    [dbo].[PersonOfInterest] WITH (NOLOCK)
        WHERE   (@PersonOfInterestIds IS NULL OR dbo.[CheckValueInList]([Id], @PersonOfInterestIds) = 1)
                AND [Deleted] = 0
                AND [Pending] = 0
                AND [Status] = 'H'
    )

    -- Sundays and holidays
    INSERT INTO #PersonDates([IdPersonOfInterest], [Date], [DateSystem])
    SELECT      P.[Id], Tzdb.ToUtc(DR.[Date]), DR.[Date]
    FROM        DateRange DR
                CROSS JOIN Persons P WITH (NOLOCK)
                INNER JOIN [dbo].[PersonOfInterestFiscalizationInfo] PFI WITH (NOLOCK) ON PFI.[IdPersonOfInterest] = P.[Id] AND PFI.[CreatedDate] <= Tzdb.ToUtc(DR.[Date])
    ORDER BY    P.[Id], DR.[Date]
    OPTION (MAXRECURSION 0);

    WITH PersonsMarks AS (
        SELECT  [IdPersonOfInterest], DATEADD(DD, DATEDIFF(DD, 0, Tzdb.FromUtc([Date])), 0) AS DateSystem
        FROM    [dbo].[Mark] WITH (NOLOCK)
        WHERE   [Date] BETWEEN @DateFrom AND Tzdb.ToUtc(DATEADD(DAY, 1, Tzdb.FromUtc(@DateTo)))
                AND (@PersonOfInterestIds IS NULL OR dbo.[CheckValueInList]([IdPersonOfInterest], @PersonOfInterestIds) = 1)
    ),
    MarksReport([Date], [IdPersonOfInterest], [EntryTime], [RestEntryTime], [RestExitTime], [ExitTime]) AS
	(
		SELECT		Tzdb.ToUtc(CAST(Tzdb.FromUtc(M.[Date]) AS [sys].[date])) AS [Date],
					MAX(M.[IdPersonOfInterest]) AS IdPersonOfInterest,
					MAX(CASE M.[Type] WHEN 'E' THEN M.[Date] ELSE NULL END) AS EntryTime,
					MAX(CASE M.[Type] WHEN 'ED' THEN M.[Date] ELSE NULL END) AS RestEntryTime,
					MAX(CASE M.[Type] WHEN 'SD' THEN M.[Date] ELSE NULL END) AS RestExitTime,
					MAX(CASE M.[Type] WHEN 'S' THEN M.[Date] ELSE NULL END) AS ExitTime
		FROM		[dbo].[Mark] M WITH (NOLOCK)
		WHERE		M.[Date] BETWEEN @DateFrom AND Tzdb.ToUtc(DATEADD(DAY, 1, Tzdb.FromUtc(@DateTo)))
                    AND (@PersonOfInterestIds IS NULL OR dbo.[CheckValueInList](M.[IdPersonOfInterest], @PersonOfInterestIds) = 1)
		GROUP BY	M.[IdPersonOfInterest], Tzdb.ToUtc(CAST(Tzdb.FromUtc(M.[Date]) AS [sys].[date]))
	)

    SELECT      P.[Id] AS IdPersonOfInterest, P.[Name] AS PersonOfInterestName, P.[LastName] AS PersonOfInterestLastName, P.[Identifier] AS PersonOfInterestIdentifier,
                PD.[Date], WS.[Id] AS IdWorkShift, WS.[StartTime] AS WorkShiftStartTime, WS.[EndTime] AS WorkShiftEndTime,
                RS.[Id] AS IdRestShift, RS.[StartTime] AS RestShiftStartTime, RS.[EndTime] AS RestShiftEndTime,
                MR.[EntryTime] AS MarkEntryTime, MR.[RestEntryTime] AS MarkRestEntryTime, MR.[RestExitTime] AS MarkRestExitTime, MR.[ExitTime] AS MarkExitTime,
                NULL AS Anomalies, NULL AS Comments
    FROM        [dbo].[PersonOfInterest] P WITH (NOLOCK)
                INNER JOIN [dbo].[PersonOfInterestFiscalizationInfo] PFI WITH (NOLOCK) ON PFI.[IdPersonOfInterest] = P.[Id]
                LEFT OUTER JOIN #PersonDates PD ON PD.[IdPersonOfInterest] = P.[Id]
                LEFT OUTER JOIN MarksReport MR ON MR.[IdPersonOfInterest] = P.[Id] AND MR.[Date] = PD.[Date]
                LEFT OUTER JOIN [dbo].[PersonOfInterestWorkShift] PWS WITH (NOLOCK) ON PWS.[IdPersonOfInterest] = P.[Id] AND PWS.[IdDayOfWeek] = DATEPART(WEEKDAY, PD.[DateSystem])
                LEFT OUTER JOIN [dbo].[WorkShift] WS WITH (NOLOCK) ON WS.[Id] = PWS.[IdWorkShift]
                LEFT OUTER JOIN [dbo].[WorkShift] RS WITH (NOLOCK) ON RS.[Id] = PWS.[IdRestShift]
    WHERE       (@PersonOfInterestIds IS NULL OR dbo.[CheckValueInList](P.[Id], @PersonOfInterestIds) = 1)
                AND (@WorkShiftIds IS NULL OR dbo.[CheckValueInList](PWS.[IdWorkShift], @WorkShiftIds) = 1)
                AND (@PlaceOfWorkIds IS NULL OR dbo.[CheckValueInList](PFI.[IdPlaceOfWork], @PlaceOfWorkIds) = 1)
                AND (@PersonOfInterestTypeCodes IS NULL OR dbo.[CheckCharValueInList](P.[Type], @PersonOfInterestTypeCodes) = 1)
                AND P.[Deleted] = 0
                AND P.[Pending] = 0
                AND P.[Status] = 'H'
    GROUP BY    P.[Id], P.[Name], P.[LastName], P.[Identifier],
                PD.[Date], WS.[Id], WS.[StartTime], WS.[EndTime],
                RS.[Id], RS.[StartTime], RS.[EndTime],
                MR.[EntryTime], MR.[RestEntryTime], MR.[RestExitTime], MR.[ExitTime]
    ORDER BY    P.[Name], P.[LastName], PD.[Date];
    
    DROP TABLE #PersonDates;
END
